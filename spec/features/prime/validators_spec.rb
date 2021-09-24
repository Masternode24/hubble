require 'features_helper'

describe 'Prime Validators' do
  include_context 'Prime user'
  include_context 'Prime Polkadot network chain account'
  include_context 'Prime Near network chain account'
  include_context 'Prime Cosmos network chain account'

  let(:cosmos_chain) { create(:cosmos_chain) }
  let(:cosmos_validator) { create(:cosmos_validator_synced, chain: cosmos_chain) }

  context 'signed in prime user' do
    before do
      travel_to Time.gm(2021, 8, 12, 16, 55, 35) do
        create(:cosmos_block, chain: cosmos_chain, proposer_address: cosmos_validator.address)
        log_in(prime_user)
        visit('/prime/validators')
      end
    end

    it 'displays Prime Validatorss Page', :vcr do
      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('Validator Performance')
      expect(page).to have_content('Avg. Uptime')
      expect(page).to have_content('99.04%')
      expect(page).to have_content('FIGMENT VALIDATORS PERFORMANCE')
      expect(page).to have_content('Polkadot (138QdRbUTB9eNY9...)')
      expect(page).to have_content('Cosmos (AC2D56057CD8476...)')
      expect(page).to have_content('98.09%')
      expect(page).to have_content('Near')
      expect(page).to have_content('99.99%')
      expect(page).to have_content('10%')
      expect(page).to have_content('VALIDATOR EVENTS')
      expect(page).to have_content('Active Set Inclusion')
    end
  end
end
