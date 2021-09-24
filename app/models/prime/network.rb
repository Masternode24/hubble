class Prime::Network < ApplicationRecord
  has_many  :chains, foreign_key: :prime_network_id, dependent: :destroy, inverse_of: :network
  has_many  :accounts, foreign_key: :prime_network_id, dependent: :destroy, inverse_of: :network
  has_many :data_points, class_name: 'Prime::Analytics::DataPoint', dependent: :destroy, inverse_of: :network

  validates :name, uniqueness: true, presence: true
  before_save :downcase_name

  scope :enabled, -> { joins(:chains).where(prime_chains: { primary: true }).where(prime_chains: { active: true }) }
  scope :analytics_enabled, -> { joins(:chains).where(prime_chains: { primary: true }).where(prime_chains: { analytics_enabled: true }) }

  def self.testing
    all - enabled
  end

  def enabled?
    primary_chain ? primary_chain.active : false
  end

  def analytics_enabled?
    primary_chain ? primary_chain.analytics_enabled : false
  end

  def to_param
    name
  end

  def primary_chain
    @primary_chain ||= chains.find_by(primary: true)
  end

  def primary
    Rollbar.error('Incorrect call to primary instead of primary_chain.')
    primary_chain
  end

  def token_metrics!
    @token_metrics ||= Prime::MessariDataService.new.token_metrics(primary_chain.reward_token_remote)
  end

  def token_price_time_series!
    @token_price_time_series ||= begin
      params = {
        'interval' => '1d'
      }
      Prime::MessariDataService.new.token_price_time_series(primary_chain.reward_token_remote, params: params)
    end
  end

  def daily_price_series_hash
    @daily_price_series_hash ||= daily_price_series_to_hash(token_price_time_series!.tohlcv_values)
  end

  def events!
    @events ||= Prime::MessariDataService.new.network_events(self).map do |event|
      if event.success
        Prime::NetworkEventDecorator.new(event)
      else
        Prime::FailedNetworkEventDecorator.new(event)
      end
    end
  end

  def figment_validators!
    @figment_validators ||= primary_chain.figment_validators
  end

  private

  def downcase_name
    name.downcase!
  end

  def daily_price_series_to_hash(series_array)
    hash = {}
    series_array.each do |point|
      hash[format_timestamp(point[0] / 1000)] = point[1]
    end
    hash[Time.now.to_s.split(' ').first] = token_metrics!.price_usd
    hash
  end

  def format_timestamp(stamp)
    Time.strptime(stamp.to_s, '%s').to_s.split(' ').first
  end
end
