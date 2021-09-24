module Prime
  module Anjin
    class Validator < Common::Resource
      field :id
      field :pubkey
      field :withdrawal_credentials
      field :amount
      field :signature
      field :deposit_message_root
      field :deposit_data_root
      field :fork_version
      field :eth2_network_name
      field :deposit_cli_version
      field :eth1_withdrawal_address
      field :staking_positions, type: StakingPosition

      def initialize(attrs)
        super(attrs.fetch('attributes', {}).merge(
          id: attrs['id'],
          staking_position: attrs.dig('relationships', 'staking_position', 'data')
        ))
      end
    end
  end
end
