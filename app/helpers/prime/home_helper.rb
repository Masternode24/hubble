module Prime::HomeHelper
  NETWORK_IMAGES = {
    'polkadot': 'polkadot.svg',
    'oasis': 'oasis.svg',
    'cosmos': 'cosmos.svg',
    'terra': 'terra.svg',
    'kava': 'kava.svg',
    'near': 'near.svg',
    'livepeer': 'livepeer.svg',
    'celo': 'celo.svg',
    'mina': 'mina.svg',
    'solana': 'solana.svg'
  }.freeze

  def active_nav_tab?(route)
    current_page?(route) ? 'active' : ''
  end

  def prime_network_image(network)
    "prime/networks/#{NETWORK_IMAGES[network.name.to_sym]}"
  end

  def decorate_user_network_reward(network, start_time: nil, end_time: nil)
    "#{number_with_delimiter(network_reward_total(network, start_time: start_time, end_time: end_time).round(2))} #{network.primary_chain.reward_token_display}"
  end
end
