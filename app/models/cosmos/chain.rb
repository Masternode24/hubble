class Cosmos::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = false # used in disabled ledger features

  DEFAULT_TOKEN_DISPLAY = 'ATOM'.freeze
  DEFAULT_TOKEN_REMOTE = 'uatom'.freeze
  DEFAULT_TOKEN_FACTOR = 6

  PREFIXES = {
    account_address: 'cosmos1',
    account_public_key: 'cosmospub1',
    validator_consensus_address: 'cosmosvalcons1',
    validator_consensus_public_key: 'cosmosvalconspub1',
    validator_operator_address: 'cosmosvaloper1',
    validator_operator_public_key: 'cosmosvaloperpub1'
  }.freeze

  scope :tx_search_enabled, -> { where(tx_search_enabled: true) }

  def network_name
    'Cosmos'
  end

  def has_csir?
    true
  end

  # used in fixed ledger features
  def supports_ledger?
    true
  end
end
