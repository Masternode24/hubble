class ApiKey < ApplicationRecord
  has_secure_token :key

  belongs_to :user

  scope :active, -> { where(deactivated_at: nil) }

  def active?
    !deactivated?
  end

  def deactivated?
    deactivated_at.present?
  end

  def deactivate
    touch(:deactivated_at)
  end

  def status
    deactivated? ? 'deactivated' : 'active'
  end
end
