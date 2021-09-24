module Prime
  module Anjin
    class StakingPosition < Common::Resource
      field :id
      field :display_name
      field :staked_eth_amount
      field :eth1_withdrawal_address

      collection :validators, type: Validator

      def initialize(attrs)
        super(attrs.fetch('attributes', {}).merge(
          id: attrs['id'],
          validators: attrs['validators']
        ))

        self.display_name ||= 'Unnamed Position'
      end
    end
  end
end
