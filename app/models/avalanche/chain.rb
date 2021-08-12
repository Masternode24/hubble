class Avalanche::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'avalanche'.freeze

  DEFAULT_TOKEN_DISPLAY = 'AVAX'.freeze
  DEFAULT_TOKEN_REMOTE = 'avax'.freeze
  DEFAULT_TOKEN_FACTOR = 9
  STALE_SYNC_TIME = 15
  DEFAULT_VALIDATOR_EVENTS = [{ 'kind' => 'validator_added', 'height' => 0 },
                              { 'kind' => 'validator_finished', 'height' => 0 },
                              { 'kind' => 'delegator_added', 'height' => 0 },
                              { 'kind' => 'delegator_finished', 'height' => 0 },
                              { 'kind' => 'validator_commission_changed', 'height' => 0 }].freeze

  has_many :alertable_addresses, as: :chain, dependent: :destroy
  has_many :alert_subscriptions, through: :alertable_addresses

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, to: :client
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  delegate :status, :get_recent_events, :get_alertable_name, to: :client

  def network_name
    'Avalanche'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def client
    @client ||= Avalanche::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end

  def last_sync_time
    @last_sync_time ||= status.sync_time
  end

  def out_of_sync?
    status&.failed?
  end

  def failing_sync?
    last_sync_time < STALE_SYNC_TIME.minutes.ago
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
