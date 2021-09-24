require 'features_helper'

describe 'Prime Admin page' do
  let!(:admin) { create(:admin) }

  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:oasis) { create(:prime_network, name: 'Oasis') }

  let!(:polkadot_chain) { create(:prime_chain, network: polkadot, name: 'Polkadot', slug: 'mainnet') }
  let!(:oasis_chain) { create(:prime_chain, network: oasis, name: 'Oasis', slug: 'main') }

  it 'signing in and adding a Polkadot chain' do
    visit '/prime/admin'

    expect(page).to have_content('Login')

    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password

    click_button 'login'

    expect(page).to have_content(polkadot.name.capitalize)
    expect(page).to have_content('Prime Admin')

    find("a[href='/prime/admin/networks/polkadot/chains/new']").click

    expect(page).to have_content('Creating New Polkadot Chain')

    fill_in 'prime_chain_name', with: 'PolkadotChain'
    fill_in 'prime_chain_slug', with: 'test-slug'
    fill_in 'prime_chain_api_url', with: 'http://localhost:9292/polkadot'
    fill_in 'prime_chain_reward_token_remote', with: 'dot'
    fill_in 'prime_chain_reward_token_display', with: 'DOT'
    fill_in 'prime_chain_reward_token_factor', with: '10'

    click_button 'Create Chain'

    expect(page).to have_content('Chain created successfully')
    expect(page).to have_content('PolkadotChain')

    find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
    click_button 'enable'
    expect(page).to have_content('Chain info has been updated!')
  end

  context 'with rpc url' do
    before do
      visit '/prime/admin'

      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password

      click_button 'login'

      first("a[href='/prime/admin/networks/polkadot/chains/#{polkadot_chain.slug}']").click
    end

    it 'updates rpc related fields' do
      fill_in 'prime_chains_polkadot_rpc_host', with: 'rpc.example.com'
      fill_in 'prime_chains_polkadot_rpc_port', with: '443'
      fill_in 'prime_chains_polkadot_rpc_api_key', with: 'secret-api-key'

      click_button 'rpc-update-button'
      expect(page).to have_content('Chain info has been updated!')
    end
  end

  context 'with validator addresses' do
    before do
      visit '/prime/admin'

      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password

      click_button 'login'

      find("a[href='/prime/admin/networks/polkadot/chains/new']").click

      fill_in 'prime_chain_name', with: 'PolkadotChain'
      fill_in 'prime_chain_slug', with: 'test-slug'
      fill_in 'prime_chain_api_url', with: 'http://localhost:9292/polkadot'
      fill_in 'prime_chain_reward_token_remote', with: 'dot'
      fill_in 'prime_chain_reward_token_display', with: 'DOT'
      fill_in 'prime_chain_reward_token_factor', with: '10'

      click_button 'Create Chain'

      find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
    end

    it 'add validator addresses' do
      fill_in 'new address', with: 'hi there'
      click_button 'address update'
      expect(page).to have_content('Chain info has been updated!')

      find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
      click_button 'enable'
      find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
      expect(page).to have_selector("input[value='hi there']")
    end

    it 'remove validator addresses' do
      fill_in 'new address', with: 'hi there'
      click_button 'address update'

      find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
      expect(page).to have_selector("input[value='hi there']")
      expect(page).to have_content('Check to remove')
      find('#prime_chains_polkadot_to_remove_0').set(true)
      click_button 'address update'
      expect(page).to have_content('Chain info has been updated!')

      find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
      expect(page).to have_no_selector("input[value='hi there']")
    end

    it 'change old validator addresses' do
      fill_in 'new address', with: 'hi there'
      click_button 'address update'

      find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
      fill_in 'addresshi there', with: 'hello world'
      click_button 'address update'
      expect(page).to have_content('Chain info has been updated!')

      find("a[href='/prime/admin/networks/polkadot/chains/test-slug']", match: :first).click
      expect(page).to have_no_selector("input[value='hi there']")
      expect(page).to have_selector("input[value='hello world']")
    end
  end

  context 'two chains' do
    before do
      visit '/prime/admin'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'login'
    end

    it 'different network different slug' do
      click_link 'Polkadot'
      expect(page).to have_content('Polkadot')

      click_link 'back'

      click_link 'Oasis'
      expect(page).to have_content('Oasis')
    end

    it 'same network same slug' do
      find("a[href='/prime/admin/networks/polkadot/chains/new']").click

      fill_in 'prime_chain_name', with: 'PolkadotChain'
      fill_in 'prime_chain_slug', with: 'mainnet'
      fill_in 'prime_chain_api_url', with: 'http://localhost:9292/polkadot'
      fill_in 'prime_chain_reward_token_remote', with: 'dot'
      fill_in 'prime_chain_reward_token_display', with: 'DOT'
      fill_in 'prime_chain_reward_token_factor', with: '10'

      click_button 'Create Chain'
      expect(page).to have_content('Slug has already been taken')
    end

    it 'different network same slug' do
      find("a[href='/prime/admin/networks/polkadot/chains/new']").click

      fill_in 'prime_chain_name', with: 'PolkadotChain'
      fill_in 'prime_chain_slug', with: 'main'
      fill_in 'prime_chain_api_url', with: 'http://localhost:9292/polkadot'
      fill_in 'prime_chain_reward_token_remote', with: 'dot'
      fill_in 'prime_chain_reward_token_display', with: 'DOT'
      fill_in 'prime_chain_reward_token_factor', with: '10'

      click_button 'Create Chain'
      expect(page).to have_content('Chain created successfully')
    end
  end
end
