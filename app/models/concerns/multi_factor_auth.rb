module MultiFactorAuth
  extend ActiveSupport::Concern

  included do
    attr_accessor :otp_code_verification

    has_one_time_password
  end

  # Require 2FA for any Prime users enrolled with Prime Staking
  def mfa_required?
    prime? && prime_eth_staking_enabled?
  end

  # Considered to be complete when secret key is added
  def mfa_enabled?
    otp_secret_key.present? && otp_enabled
  end

  def generate_otp_secret_key
    if otp_secret_key.blank?
      update(otp_secret_key: ROTP::Base32.random_base32)
    end
  end

  def enable_mfa(code)
    if code.blank?
      errors.add(:base, 'OTP code is required')
      return false
    end

    if mfa_enabled?
      errors.add(:base, 'MFA is already enabled')
      return false
    end

    if otp_secret_key.blank?
      errors.add(:base, 'MFA configuration is not complete')
      return false
    end

    if !authenticate_otp(code)
      errors.add(:base, 'OTP code is not valid')
      return false
    end

    update(otp_enabled: true, otp_enabled_at: Time.current)
  end

  def disable_mfa
    update(otp_enabled: false, otp_enabled_at: nil)
  end
end
