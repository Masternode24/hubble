shared_context 'Prime Near network chain account' do
  include_context 'Prime user'
  let!(:near) { create(:prime_network, name: 'Near') }

  let!(:near_chain) do
    create(:prime_chain,
           network: near,
           name: 'Mainnet',
           slug: 'mainnet',
           type: 'Prime::Chains::Near',
           api_url: 'https://localhost:3333',
           reward_token_factor: 24,
           reward_token_remote: 'near',
           reward_token_display: 'NEAR',
           figment_validator_addresses: ['p2p-org.poolv1.near'])
  end

  let!(:near_account) do
    create(:prime_account,
           user: prime_user,
           network: near,
           name: 'near account 0',
           type: 'Prime::Accounts::Near',
           address: 'figment.near')
  end

  let!(:near_account_no_delegation) do
    create(:prime_account,
           user: prime_user,
           network: near,
           type: 'Prime::Accounts::Near',
           address: '582d15d089225c0595b14ac4359dc854466dacc271304d14ab2d5c15491f4cf4')
  end
end
