class Prime::Chain < ApplicationRecord
  RPC_PROXY_READ_TIMEOUT = 60
  RPC_PROXY_OPEN_TIMEOUT = nil

  validates :name, presence: true

  validates :type, presence: true
  validates :api_url, presence: true
  validates :slug, presence: true, uniqueness: { scope: :network }
  validates :reward_token_remote, presence: true
  validates :reward_token_display, presence: true
  validates :reward_token_factor, presence: true

  belongs_to :network, foreign_key: :prime_network_id, inverse_of: :chains

  after_save :ensure_single_primary_chain

  alias_attribute :primary_token_divisor, :reward_token_factor

  attr_accessor :to_remove

  scope :active, -> { where(active: true) }
  scope :primary_chain, -> { find_by(primary: true) || order('created_at DESC').first }

  def to_param
    slug
  end

  def client
    raise NotImplementedError
  end

  def figment_validators
    raise NotImplementedError
  end

  def account_valid?
    raise NotImpementedError
  end

  def rpc_uri
    URI::Generic.build(scheme: use_ssl_for_rpc ? 'https' : 'http', host: rpc_host, port: rpc_port)
  end

  private

  def ensure_single_primary_chain
    network.chains.where.not(id: id).update_all(primary: false) if primary?
  end
end
