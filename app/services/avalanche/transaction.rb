module Avalanche
  class Transaction < Common::Resource
    TYPE_NAMES = {
      'P-Chain' => {
        'p_create_chain' => 'Create Chain',
        'p_create_subnet' => 'Create Subnet',
        'p_add_subnet_validator' => 'Add Subnet Validator',
        'p_add_delegator' => 'Add Delegator',
        'p_add_validator' => 'Add Validator',
        'p_reward_validator' => 'Reward Validator',
        'p_import' => 'Import',
        'p_export' => 'Export'
      },
      'X-Chain' => {
        'x_export' => 'Export',
        'x_import' => 'Import',
        'x_base' => 'Transfer',
        'x_operation' => 'Operation',
        'x_create_asset' => 'Create Asset'
      },
      'C-Chain' => {
        'c_atomic_import' => 'Atomic Import',
        'c_atomic_export' => 'Atomic Export',
        'c_evm' => 'EVM Transaction'
      }
    }.freeze

    field :id
    field :reference_tx_id
    field :type
    field :chain
    field :block
    field :block_height
    field :timestamp, type: :timestamp
    field :fee
    field :memo
    field :memo_text
    field :source_chain
    field :destination_chain
    field :input_amounts
    field :output_amounts
    field :metadata

    collection :inputs, type: Avalanche::TransactionOutput
    collection :outputs, type: Avalanche::TransactionOutput

    def chain_alias
      type.split('_').first.capitalize
    end

    def type_name
      TYPE_NAMES.values.each do |t|
        return t[type] if t.key?(type)
      end
      type
    end
  end
end
