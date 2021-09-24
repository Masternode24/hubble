shared_context 'Prime Cosmos network chain account' do
  include_context 'Prime user'

  let!(:cosmos) { create(:prime_network, name: 'Cosmos') }
  let!(:cosmos_prime_chain) do
    create(:prime_chain,
           network: cosmos,
           name: 'Cosmoshub',
           slug: 'cosmoshub-4',
           type: 'Prime::Chains::Cosmos',
           api_url: 'https://localhost:4444',
           reward_token_factor: 6,
           reward_token_remote: 'cosmos',
           reward_token_display: 'ATOM',
           genesis_block_time: '2021-02-18 07:23:53 -0500',
           figment_validator_addresses: ['AC2D56057CD84765E6FBE318979093E8E44AA18F'])
  end

  let!(:cosmos_prime_account) do
    create(:prime_account,
           user: prime_user,
           network: cosmos,
           name: 'account 0',
           type: 'Prime::Accounts::Cosmos',
           address: 'cosmos1lr0rtlsse60slsljas2y2f3ew7skm26yd9wvf8')
  end
end
