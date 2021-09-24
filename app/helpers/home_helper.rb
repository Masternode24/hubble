module HomeHelper
  def primary_chains
    @primary_chains ||= [
      *Avalanche::Chain.enabled.primary,
      *Celo::Chain.enabled.primary,
      *Cosmos::Chain.alive.has_synced.primary,
      *Emoney::Chain.alive.has_synced.primary,
      *Iris::Chain.alive.has_synced.primary,
      *Kava::Chain.alive.has_synced.primary,
      *Livepeer::Chain.enabled.primary,
      *Mina::Chain.enabled.primary,
      *Near::Chain.enabled.primary,
      *Oasis::Chain.enabled.primary,
      *Polkadot::Chain.enabled.primary,
      *Skale::Chain.enabled.primary,
      *Terra::Chain.alive.has_synced.primary,
      *Tezos::Chain.enabled.primary
    ]
  end

  def decorated_primary_chains
    @decorated_primary_chains ||=
      primary_chains.map do |chain|
        chain.class.parent::HomeChainDecorator.new(chain)
      end.sort_by! { |chain| chain.network_name.downcase }
  end

  NETWORKS_IMAGES = {
    'Avalanche' => 'avalanche.svg',
    'Celo' => 'celo.svg',
    'Cosmos' => 'cosmos.svg',
    'Crypto' => 'crypto.svg',
    'e-Money' => 'e-money.png',
    'IRIS' => 'iris.svg',
    'Kava' => 'kava.svg',
    'Livepeer' => 'livepeer.svg',
    'Mina' => 'mina.svg',
    'NEAR' => 'near.svg',
    'Oasis' => 'oasis.svg',
    'Polkadot' => 'polkadot.png',
    'Skale' => 'skale.svg',
    'Terra' => 'terra.svg',
    'Tezos' => 'tezos.png'
  }.freeze

  def network_has_image?(network_name)
    NETWORKS_IMAGES.include?(network_name)
  end

  def network_image(network_name)
    NETWORKS_IMAGES[network_name]
  end
end
