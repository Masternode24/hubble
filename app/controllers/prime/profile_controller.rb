class Prime::ProfileController < Prime::ApplicationController
  before_action :set_metadata

  def show
    unless current_user.mfa_enabled?
      current_user.generate_otp_secret_key
      @mfa_qr = generate_mfa_qr
    end
  end

  def verify_mfa
    if current_user.enable_mfa(user_params[:otp_code_verification])
      flash[:success] = 'Multi-Factor authentication has been enabled!'
    else
      flash[:error] = "Multi-Factor authentication setup failed: #{current_user.errors[:base].first}"
    end

    redirect_to prime_profile_path
  end

  def disable_mfa
    if current_user.disable_mfa
      flash[:success] = 'Multi-Factor authentication has been disabled'
    else
      flash[:error] = 'Disabling multi-factor authentication failed'
    end

    redirect_to prime_profile_path
  end

  private

  def set_metadata
    @page_title = 'My Profile'
  end

  def generate_mfa_qr
    issuer = 'Figment Prime'
    issuer << " (#{Rails.env})" unless Rails.env.production?

    parts = [
      'otpauth://totp/', current_user.email,
      '?secret=', current_user.otp_secret_key,
      '&issuer=', issuer
    ].join('')

    RQRCode::QRCode.new(parts)
  end

  def user_params
    params.require(:user).permit(:otp_code_verification)
  end
end
