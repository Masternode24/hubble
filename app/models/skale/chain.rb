class Skale::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'skale'.freeze

  DEFAULT_TOKEN_DISPLAY = 'SKL'.freeze
  DEFAULT_TOKEN_REMOTE = 'skl'.freeze
  DEFAULT_TOKEN_FACTOR = 18

  # Extract in future if used elsewhere
  ETHEREUM_MAINNET_CHAIN_ID = 1
  ETHEREUM_RINKEBY_CHAIN_ID = 4

  DEFAULT_VALIDATOR_EVENTS = [{ 'kind' => 'joined_active_set', 'height' => 0 },
                              { 'kind' => 'left_active_set', 'height' => 0 },
                              { 'kind' => 'slashed', 'height' => 0 },
                              { 'kind' => 'kicked', 'height' => 0 },
                              { 'kind' => 'forgiven', 'height' => 0 }].freeze

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, :get_recent_events, :get_alertable_name, to: :client

  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  has_many :alertable_addresses, as: :chain, dependent: :destroy
  has_many :alert_subscriptions, through: :alertable_addresses

  def network_name
    'Skale'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def client
    @client ||= Skale::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end

  def failing_sync?
    !status.success?
  end

  def supports_ledger?
    !testnet?
  end

  def ethereum_chain_id
    Rails.env.production? ? ETHEREUM_MAINNET_CHAIN_ID : ETHEREUM_RINKEBY_CHAIN_ID
  end

  # Event Subscription requirements
  def validator_event_defs
    DEFAULT_VALIDATOR_EVENTS
  end

  def has_dashboard?
    true
  end

  def namespace
    self.class.name.deconstantize.constantize
  end

  def alertable_type
    'validator'
  end

  def get_events_for_alert(subscription, _seconds_ago, date = nil)
    after_time = date&.beginning_of_day || subscription.last_instant_at
    before_time = date&.end_of_day || Time.current

    client.validator_events(
      chain: self,
      address: subscription.alertable.address,
      start_time: after_time,
      end_time: before_time
    )
  end

  def get_recent_events(chain, address, kind_class, after_time)
    client.validator_events(chain: chain, address: address, kind_class: kind_class, start_time: after_time)
  end
end
