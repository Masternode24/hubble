class Crypto::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = false

  DEFAULT_TOKEN_DISPLAY = 'CRO'.freeze
  DEFAULT_TOKEN_REMOTE = 'basecro'.freeze
  DEFAULT_TOKEN_FACTOR = 8

  # needs to be confirmed
  PREFIXES = {
    account_address: 'cro1',
    account_public_key: 'cropub1',
    validator_consensus_address: 'crocnclcons1',
    validator_consensus_public_key: 'crocnclconspub1',
    validator_operator_address: 'crocncl1',
    validator_operator_public_key: 'crocnclpub1'
  }.freeze

  TESTNET_PREFIXES = {
    account_address: 'tcro1',
    account_public_key: 'tcropub1',
    validator_consensus_address: 'tcrocnclcons1',
    validator_consensus_public_key: 'tcrocnclconspub1',
    validator_operator_address: 'tcrocncl1',
    validator_operator_public_key: 'tcrocnclpub1'
  }.freeze

  def network_name
    'Crypto'
  end

  def prefixes
    testnet? ? TESTNET_PREFIXES : PREFIXES
  end

  def staked_amount
    validators.sum(&:current_voting_power)
  end
end
