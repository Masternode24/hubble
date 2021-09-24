shared_context 'Prime Terra network chain account' do
  include_context 'Prime user'

  let!(:terra) { create(:prime_network, name: 'Terra') }

  let!(:terra_chain) do
    create(:prime_chain,
           network: terra,
           name: 'Columbus',
           slug: 'columbus-4',
           type: 'Prime::Chains::Terra',
           api_url: 'https://localhost:5555',
           reward_token_factor: 6,
           reward_token_remote: 'terra',
           reward_token_display: 'LUNA',
           genesis_block_time: '2020-10-03 11:56:10 -0400')
  end

  let!(:terra_account) do
    create(:prime_account,
           user: prime_user,
           network: terra,
           name: 'terra account 0',
           type: 'Prime::Accounts::Terra',
           address: 'terra18npmlvy8aedc6rzyhm6gkwdyd070cquatlmqtc')
  end
end
