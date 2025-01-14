class SessionsController < ApplicationController
  MFA_MAX_ATTEMPTS = 5
  MFA_TIMEOUT = 300

  before_action :check_mfa_session, only: :verify

  layout 'account'

  def new
    page_title 'Hubble', 'Login'
    referrer = URI(request.referer) rescue nil
    if referrer && Rails.application.secrets.application_host
      referrer.host, referrer.port = Rails.application.secrets.application_host.split(':')
      referrer.port = nil if referrer.port == 80
      @return_path = referrer.to_s
    end
  end

  def create
    user = User.find_by email: params[:email].try(:downcase)

    if user.nil?
      flash[:error] = 'Invalid email or password.'
      redirect_to params[:prime] == 'true' ? prime_login_path : login_path
      return
    end

    if !user.verified?
      redirect_to welcome_users_path
      return
    end

    if user.authenticate(params[:password]) && !user.deleted?
      # Require users to validate login via OTP code.
      # Users are given X minutes and Y attempts before MFA session is cleared.
      if user.mfa_enabled?
        cleanup_mfa_session
        setup_mfa_session(user)
        return redirect_to login_verify_path
      end

      setup_user_session(user)

      if params[:prime] == 'true'
        redirect_to prime_root_path
      else
        redirect_to params_return_path || root_path
      end

      return
    end

    flash[:error] = 'Invalid email or password.'
    if params[:prime] == 'true'
      redirect_to prime_login_path(return_path: params_return_path)
    else
      redirect_to login_path(return_path: params_return_path)
    end
  end

  def verify
    return unless request.post?

    user = User.find(session[:mfa_user_id])
    if !user.authenticate_otp(params[:otp_code])
      flash[:error] = 'Invalid OTP code.'
      return
    end

    setup_user_session(user)

    path = session[:mfa_redirect_path]
    cleanup_mfa_session
    redirect_to(path)
  end

  def forgot_password; end

  def reset_password
    user = User.find_by email: params[:email].downcase
    if user&.verified?
      user.update password_reset_token: SecureRandom.hex
      UserMailer.with(user: user).forgot_password.deliver_now
    else
      redirect_to forgot_password_path
    end
  end

  def recover_password
    @user = User.find_by password_reset_token: params[:token]
    raise ActiveRecord::RecordNotFound if !@user

    session[:uid] = @user.id
    session[:masq] = nil
    @user.update password_reset_token: nil
    flash[:notice] = 'Logged in. You may reset your password now.'
    redirect_to settings_users_path
  end

  def destroy
    admin_id = session[:admin_id]
    session[:masq] = nil
    session[:uid] = nil
    reset_session
    session[:admin_id] = admin_id if admin_id.present?
    redirect_to root_path
  end

  private

  def setup_user_session(user)
    session[:uid] = user.id
    session[:masq] = nil

    user.update_for_login(ua: request.env['HTTP_USER_AGENT'], ip: current_ip)
  end

  def check_mfa_session
    if session[:mfa_validation_id].blank? || session[:mfa_user_id].blank?
      return cancel_mfa_session
    end

    if session[:mfa_expires_after].to_i < Time.current.to_i
      return cancel_mfa_session
    end

    if request.post?
      session[:mfa_attempts_count] = session[:mfa_attempts_count].to_i + 1
      if session[:mfa_attempts_count] > MFA_MAX_ATTEMPTS
        cancel_mfa_session
      end
    end
  end

  def setup_mfa_session(user)
    session[:mfa_expires_after] = Time.current.to_i + MFA_TIMEOUT
    session[:mfa_validation_id] = SecureRandom.hex(20)
    session[:mfa_redirect_path] = params[:prime] == 'true' ? prime_root_path : (params_return_path || root_path)
    session[:mfa_user_id] = user.id
  end

  def cleanup_mfa_session
    session.to_h.each_pair do |k, _|
      session.delete(k) if k.starts_with?('mfa_')
    end
  end

  def cancel_mfa_session
    cleanup_mfa_session
    redirect_to(root_path)
  end
end
