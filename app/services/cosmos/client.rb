module Cosmos
  class Client < Cosmoslike::Client
    DEFAULT_TIMEOUT = 30
    DEFAULT_REWARDS_REQUEST_LENGTH = 90.days

    def account(address)
      Cosmos::AccountDecorator.new(Cosmos::Chain.primary, address)
    end

    def prime_rewards(account, start_time, end_time)
      Rails.cache.fetch([self.class.name, 'rewards', account.address].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        token_factor = account.network.primary_chain.reward_token_factor
        token_display = account.network.primary_chain.reward_token_display
        start_time ||= DEFAULT_REWARDS_REQUEST_LENGTH.ago.iso8601 unless start_time
        end_time ||= Time.now.utc.iso8601 unless end_time

        list = []
        Prime::Chains::Cosmos.active.order(:genesis_block_time).reverse.each do |chain|
          next unless chain.genesis_block_time < end_time
          next unless chain.final_block_time.nil? || (chain.final_block_time > start_time)

          get('/rewards', network: 'cosmos', chain_id: chain.slug, account: account.address, start_time: start_time, end_time: end_time).each do |reward|
            list << reward
          end
        end

        list.map do |reward|
          Prime::Reward::Cosmos.new(reward, account, token_factor: token_factor, token_display: token_display)
        end
      end
    end
  end
end
