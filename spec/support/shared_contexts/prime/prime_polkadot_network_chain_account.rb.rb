shared_context 'Prime Polkadot network chain account' do
  include_context 'Prime user'
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }

  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot',
           api_url: 'http://localhost:8081',
           figment_validator_addresses: %w[138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB
                                           12NEHw7QgwX61xGe9kahhVqMGCi6MY8fq6iBcwNJvj3Y7Nwj])
  end

  let!(:polkadot_account) do
    create(:prime_account,
           user: prime_user,
           network: polkadot,
           name: 'polkadot account 0',
           address: '138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB')
  end
end
