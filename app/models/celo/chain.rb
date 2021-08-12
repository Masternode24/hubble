class Celo::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'celo'.freeze

  DEFAULT_TOKEN_DISPLAY = 'CELO'.freeze
  DEFAULT_TOKEN_REMOTE = 'celo'.freeze
  DEFAULT_TOKEN_FACTOR = 18
  STALE_SYNC_TIME = 15
  DEFAULT_VALIDATOR_EVENTS = [{ 'kind' => 'active_set_inclusion', 'height' => 0 },
                              { 'kind' => 'reward_cut_change', 'height' => 0 },
                              { 'kind' => 'n_of_m', 'n' => 50, 'm' => 1000, 'height' => 0 },
                              { 'kind' => 'n_consecutive', 'n' => 150, 'height' => 0 }].freeze

  has_many :alertable_addresses, as: :chain, dependent: :destroy
  has_many :alert_subscriptions, through: :alertable_addresses

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, :get_alertable_name, to: :client
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  def network_name
    'Celo'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def client
    @client ||= Celo::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end

  def last_sync_time
    @last_sync_time ||= status.last_indexed_time
  end

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
    after_time = date ? date.beginning_of_day : subscription.last_instant_at
    before_time = date ? date.end_of_day : Time.now

    client.validator_events(chain: self, address: subscription.alertable.address, after_time: after_time,
                            before_time: before_time)
  end

  def get_recent_events(chain, address, kind_class, after_time)
    client.validator_events(chain: chain, address: address, kind_class: kind_class, after_time: after_time)
  end

  def failing_sync?
    last_sync_time < STALE_SYNC_TIME.minutes.ago
  end
end
