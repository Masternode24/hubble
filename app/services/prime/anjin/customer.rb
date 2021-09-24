module Prime
  module Anjin
    class Customer < Common::Resource
      field :id
      field :name

      collection :staking_positions, type: StakingPosition

      def initialize(attrs)
        super(attrs.fetch('attributes', {}).merge(
          id: attrs['id'],
          staking_positions: attrs.dig('relationships', 'eth2_staking_positions', 'data')
        ))
      end
    end
  end
end
