shared_context 'Prime Oasis network chain account' do
  include_context 'Prime user'
  let!(:oasis) { create(:prime_network, name: 'Oasis') }

  let!(:oasis_chain) do
    create(:prime_chain,
           network: oasis,
           name: 'Mainnet',
           slug: 'mainnet',
           type: 'Prime::Chains::Oasis',
           api_url: 'https://localhost:1111',
           reward_token_factor: 9,
           reward_token_remote: 'rose',
           reward_token_display: 'ROSE')
  end

  let!(:oasis_account) do
    create(:prime_account,
           user: prime_user,
           network: oasis,
           name: 'oasis account 0',
           type: 'Prime::Accounts::Oasis',
           address: 'oasis1qzkdwhw4hnu2pl49c6kpm8znh83uagvh9q7l8m2w')
  end
end
