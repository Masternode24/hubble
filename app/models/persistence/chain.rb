class Persistence::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = false

  # to be confirmed
  DEFAULT_TOKEN_DISPLAY = 'XPRT'.freeze
  DEFAULT_TOKEN_REMOTE = 'xprt'.freeze
  DEFAULT_TOKEN_FACTOR = 8

  # needs to be confirmed
  PREFIXES = {
    account_address: 'cro1',
    account_public_key: 'cro1',
    validator_consensus_address: 'croc',
    validator_consensus_public_key: 'cro1',
    validator_operator_address: 'croc',
    validator_operator_public_key: 'cro1'
  }.freeze

  TESTNET_PREFIXES = {
    account_address: 'cro1',
    account_public_key: 'cro1',
    validator_consensus_address: 'croc',
    validator_consensus_public_key: 'cro1',
    validator_operator_address: 'croc',
    validator_operator_public_key: 'cro1'
  }.freeze

  def network_name
    'Persistence'
  end

  def prefixes
    testnet? ? TESTNET_PREFIXES : PREFIXES
  end

  def staked_amount
    validators.sum(&:current_voting_power)
  end
end
