FactoryBot.define do
  factory :crypto_governance_proposal, class: 'Crypto::Governance::Proposal' do
    ext_id { 27 }
    title { 'Core upgrade 1' }
    description do
      'Example governance proposal upgrade text'
    end
    proposal_type { 'cosmos-sdk/TextProposal' }
    proposal_status { 'VotingPeriod' }
    tally_result_yes { 85986459559457 }
    tally_result_abstain { 535408864 }
    tally_result_no { 21169926706 }
    tally_result_nowithveto { 106144492 }
    submit_time { '2020-07-12 06:23:02.440964' }
    total_deposit { [{ 'denom': 'cro', 'amount': '512000000' }] }
    voting_start_time { '2020-07-13 01:37:47.298505' }
    voting_end_time { '2020-07-27 01:37:47.298505' }
    created_at { '2020-07-23 15:40:21.978086' }
    updated_at { '2020-07-23 15:40:25.969945' }
    deposit_end_time { '2020-07-26 06:23:02.440964' }
    additional_data { {} }
    finalized { false }
  end
end
