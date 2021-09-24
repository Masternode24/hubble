class User < ApplicationRecord
  MASQ_TIMEOUT = 10.minutes

  include MultiFactorAuth

  has_secure_password

  has_many :alert_subscriptions
  has_many :watches, class_name: 'Common::Watch'
  has_one :telegram_account, class_name: 'Telegram::Account'

  has_many :livepeer_delegator_lists, class_name: 'Livepeer::DelegatorList'

  has_many :prime_accounts, class_name: 'Prime::Account', dependent: :destroy, inverse_of: :user

  has_many :api_keys, dependent: :delete_all

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  default_scope -> { where.not(deleted: true) }

  scope :with_telegram_account, lambda {
                                  left_joins(:telegram_account).where.not(telegram_accounts: { id: nil, chat_id: nil })
                                }
  scope :with_subscriptions, ->(network) { where.not("#{network.downcase}_subscriptions_count" => 0) }
  scope :with_prime_access, -> { where(prime: true) }

  before_save do
    validate_prime_eth_staking_customer
  end

  def network_balances
    network_balances ||= begin
      balances = {}

      Prime::Network.enabled.each do |network|
        prime_accounts.includes(:network).for_network(network).each do |account|
          account = "Prime::#{network.name.capitalize}::AccountDecorator".constantize.new(account)
          if balances[network.name]
            balances[network.name] += account.balance
          else
            balances[network.name] = account.balance
          end
        end
        if !balances[network.name]
          balances[network.name] = 0
        end
      end
      balances
    end
  end

  def self.subscribed_to(alertable)
    ids = AlertSubscription.where(alertable: alertable).pluck(:user_id)
    where(id: ids)
  end

  def has_telegram_account?
    telegram_account.present? && telegram_account.chat_id.present?
  end

  def verified?
    verification_token.nil?
  end

  def subscribed_to?(alertable)
    alert_subscriptions.where(alertable: alertable).exists?
  end

  def update_for_request(ua:, ip:)
    self.last_seen_at = Time.now
    update_details ua: ua, ip: ip
    save
  end

  def update_for_login(ua:, ip:)
    self.last_login_at = Time.now
    self.last_seen_at = Time.now
    update_details ua: ua, ip: ip
    save
  end

  def update_for_signup(ua:, ip:)
    update_details ua: ua, ip: ip
    save
  end

  private

  def update_details(ua:, ip:)
    if ua
      json_ua = JsonUserAgent.new(ua).as_json.to_json
      self.user_agents = [json_ua, *(user_agents || [])].uniq.slice(0, 5)
    end

    if ip
      self.ip_addresses = [ip, *(ip_addresses || [])].uniq.slice(0, 5)
    end
  end

  # Perform actual customer ID validation via an Anjin API call
  def validate_prime_eth_staking_customer
    return unless prime
    return unless changes[:prime_eth_staking_customer_id]
    return if prime_eth_staking_customer_id.blank?

    Prime::Anjin::Client.current.customer(prime_eth_staking_customer_id)
  rescue Common::Client::NotFoundError
    errors.add(:prime_eth_staking_customer_id, 'is not a valid customer ID')
    throw :abort
  rescue StandardError => err
    errors.add(:prime_eth_staking_customer_id, err.message)
    throw :abort
  end
end
