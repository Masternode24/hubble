class Near::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'near'.freeze

  DEFAULT_TOKEN_DISPLAY = 'NEAR'.freeze
  DEFAULT_TOKEN_REMOTE  = 'near'.freeze
  DEFAULT_TOKEN_FACTOR  = 9
  STALE_SYNC_TIME = 15

  has_many :alertable_addresses, as: :chain, dependent: :destroy
  has_many :alert_subscriptions, through: :alertable_addresses

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: { case_sensitive: false }
  validates :api_url, presence: true

  scope :enabled, -> { where(disabled: false) }
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }

  delegate :status, :get_recent_events, :get_alertable_name, to: :client

  def self.token_map
    {
      'default' => {
        'near' => {
          'factor' => 24, 'display' => 'Ⓝ', 'primary' => true
        }
      }
    }
  end

  def network_name
    'NEAR'
  end

  def to_param
    slug
  end

  def namespace
    self.class.name.deconstantize.constantize
  end

  def enabled?
    !disabled
  end

  def has_dashboard?
    true
  end

  def out_of_sync?
    status&.stale?
  end

  def failing_sync?
    last_sync_time < STALE_SYNC_TIME.minutes.ago
  end

  def client
    @client ||= Near::Client.new(api_url)
  end

  def last_sync_time
    @last_sync_time ||= status.last_block_time
  end

  def alertable_type
    'validator'
  end

  def get_events_for_alert(subscription, seconds_ago, date = nil)
    client.get_events_for_alert(self, subscription, seconds_ago, date)
  end
end
