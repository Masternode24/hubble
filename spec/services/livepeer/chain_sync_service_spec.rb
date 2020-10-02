require 'rails_helper'

RSpec.describe Livepeer::ChainSyncService, livepeer: %i[graph factory] do
  subject { described_class.new(chain) }

  let!(:chain) { create(:livepeer_chain, last_sync_time: 1.day.ago) }

  before do
    stub_graph_query(Livepeer::Queries::Graph::RoundsQuery)
    stub_graph_query(Livepeer::Queries::Graph::StakesQuery)
    stub_graph_query(Livepeer::Queries::Graph::BondsQuery)
    stub_graph_query(Livepeer::Queries::Graph::UnbondsQuery)
    stub_graph_query(Livepeer::Queries::Graph::RebondsQuery)
    stub_graph_query(Livepeer::Queries::Graph::OrchestratorsQuery)
    stub_graph_query(Livepeer::Queries::Graph::DelegatorsQuery)
    stub_graph_query(Livepeer::Queries::Graph::RewardCutChangesQuery)
    stub_graph_query(Livepeer::Queries::Graph::MissedRewardCallsQuery)
    stub_graph_query(Livepeer::Queries::Graph::DeactivationsQuery)
    stub_graph_query(Livepeer::Queries::Graph::SlashingsQuery)
  end

  before do
    allow_any_instance_of(ThreeboxClient).to receive(:fetch_space) do
      json_fixture('livepeer/orchestrator_profile.json')
    end
  end

  it 'synchronizes rounds' do
    subject.call

    rounds = chain.rounds.order(:created_at)

    expect(rounds.count).to eq(2)

    expect(rounds[0].number).to eq(1663)
    expect(rounds[0].initialized_at).to eq('2020-03-01 10:31:28')
    expect(rounds[0].mintable_tokens).to eq(BigDecimal('17859.737930247454986706'))

    expect(rounds[1].number).to eq(1664)
    expect(rounds[1].initialized_at).to eq('2020-03-02 07:54:25')
    expect(rounds[1].mintable_tokens).to eq(BigDecimal('17817.375673954043909133'))
  end

  it "doesn't delete remaining rounds" do
    rounds = [
      create_round(chain, number: 1662, initialized_at: 4.days.ago),
      create_round(chain, number: 1663, initialized_at: 3.days.ago),
      create_round(chain, number: 1664, initialized_at: 2.days.ago),
      create_round(chain, number: 1665, initialized_at: 1.day.ago)
    ]

    subject.call

    expect(chain.rounds.count).to eq(4)

    expect(rounds.map(&:reload)).to all(be_persisted)
  end

  it 'synchronizes pools' do
    subject.call

    pools = chain.pools.order(:created_at)

    expect(pools.count).to eq(6)

    expect(pools[0].round.number).to eq(1663)
    expect(pools[0].orchestrator_address).to eq('0x0119a06b51c83d0eec79708b921a57247dc37e66')
    expect(pools[0].total_stake).to eq(BigDecimal('11899.397590785399894921'))
    expect(pools[0].fees).to eq(nil)
    expect(pools[0].reward_tokens).to eq(BigDecimal('16.823873130293102597'))

    expect(pools[1].round.number).to eq(1663)
    expect(pools[1].orchestrator_address).to eq('0x21d1130dc36958db75fbb0e5a9e3e5f5680238ff')
    expect(pools[1].total_stake).to eq(BigDecimal('264878.819105461471433604'))
    expect(pools[1].fees).to eq(nil)
    expect(pools[1].reward_tokens).to eq(BigDecimal('374.750880990382347986'))

    expect(pools[2].round.number).to eq(1663)
    expect(pools[2].orchestrator_address).to eq('0x31990bebc4fd07ac4898e7c67210f38651f1d2e8')
    expect(pools[2].total_stake).to eq(BigDecimal('60463.188906887185894603'))
    expect(pools[2].fees).to eq(nil)
    expect(pools[2].reward_tokens).to eq(BigDecimal('85.530284947955061931'))
  end

  it 'synchronizes shares' do
    subject.call

    shares = chain.pools[0].shares.order(:created_at)

    expect(shares[0].delegator_address).to eq('0x0119a06b51c83d0eec79708b921a57247dc37e66')
    expect(shares[0].fees).to eq(nil)
    expect(shares[0].reward_tokens).to eq(BigDecimal('0.338605305004622307'))

    expect(shares[1].delegator_address).to eq('0x1161f84e66fd7e810f0bd81c9d17d19007b13dc9')
    expect(shares[1].fees).to eq(nil)
    expect(shares[1].reward_tokens).to eq(BigDecimal('0.645740996368581426'))

    shares = chain.pools[1].shares.order(:created_at)

    expect(shares[0].delegator_address).to eq('0x03d66da60a634efb0228fc85dc5d76681a3abef3')
    expect(shares[0].fees).to eq(nil)
    expect(shares[0].reward_tokens).to eq(BigDecimal('0.013150773021222758'))

    expect(shares[1].delegator_address).to eq('0x0ad65faede353a3657e40e3c460fb4eb22ae6f0f')
    expect(shares[1].fees).to eq(nil)
    expect(shares[1].reward_tokens).to eq(BigDecimal('0.271545691573356426'))
  end

  it 'synchronizes stakes' do
    subject.call

    stakes = chain.rounds[0].stakes.order(:created_at)

    expect(stakes.count).to eq(3)

    expect(stakes[0].delegator_address).to eq('0x000817415963a38c16ba6ccc98f4002684c97697')
    expect(stakes[0].pending_stake).to eq(BigDecimal('0.000000000000007995'))
    expect(stakes[0].unclaimed_stake).to eq(0)

    expect(stakes[1].delegator_address).to eq('0x00260ddd1d175bf20c18f1407162db63b840b944')
    expect(stakes[1].pending_stake).to eq(BigDecimal('96.820278948273318209'))
    expect(stakes[1].unclaimed_stake).to eq(BigDecimal('15.268394467249139763'))

    expect(stakes[2].delegator_address).to eq('0x002f9caf40a444f20813da783d152bdfaf42852f')
    expect(stakes[2].pending_stake).to eq(BigDecimal('1105.861010861148433724'))
    expect(stakes[2].unclaimed_stake).to eq(BigDecimal('94.063533208389048582'))
  end

  it 'synchronizes bonds' do
    subject.call

    bonds = chain.bonds.order(:created_at)

    expect(bonds.count).to eq(6)

    expect(bonds[0].transaction_hash).to start_with('0xd3db77b9509f2eed37955803f5b3e8b7')
    expect(bonds[0].round.number).to eq(1663)
    expect(bonds[0].delegator_address).to eq('0x08c5565c3db883100f7d4e9288dc35aef37ff4d0')
    expect(bonds[0].orchestrator_address).to eq('0xe9e284277648fcdb09b8efc1832c73c09b5ecf59')
    expect(bonds[0].old_orchestrator_address).to eq('0xdac817294c0c87ca4fa1895ef4b972eade99f2fd')
    expect(bonds[0].amount).to eq(18)
    expect(bonds[0].initialized_at).to eq('2020-03-16 03:42:30')

    expect(bonds[1].transaction_hash).to start_with('0xdb73beee81f4e111e78e363da1fe5eaf')
    expect(bonds[1].round.number).to eq(1663)
    expect(bonds[1].delegator_address).to eq('0x3643962417da87156836052af92647810dc65d49')
    expect(bonds[1].orchestrator_address).to eq('0xe9e284277648fcdb09b8efc1832c73c09b5ecf59')
    expect(bonds[1].old_orchestrator_address).to eq('0x0000000000000000000000000000000000000000')
    expect(bonds[1].amount).to eq(BigDecimal('258.484014142942874461'))
    expect(bonds[1].initialized_at).to eq('2020-03-16 04:53:07')

    expect(bonds[2].transaction_hash).to start_with('0x146ffc79c570f91570f681319e121cde')
    expect(bonds[2].round.number).to eq(1663)
    expect(bonds[2].delegator_address).to eq('0xa3a549d8d10d7ef34eaef65377d9ce388369efa3')
    expect(bonds[2].orchestrator_address).to eq('0xda43d85b8d419a9c51bbf0089c9bd5169c23f2f9')
    expect(bonds[2].old_orchestrator_address).to eq('0xda43d85b8d419a9c51bbf0089c9bd5169c23f2f9')
    expect(bonds[2].amount).to eq(303)
    expect(bonds[2].initialized_at).to eq('2020-03-17 05:15:11')
  end

  it 'synchronizes unbonds' do
    subject.call

    unbonds = chain.unbonds.order(:created_at)

    expect(unbonds.count).to eq(4)

    expect(unbonds[0].transaction_hash).to start_with('0x0c9411efb3b0904ad154d065966965f7')
    expect(unbonds[0].round.number).to eq(1663)
    expect(unbonds[0].delegator_address).to eq('0xa20416801ac2eacf2372e825b4a90ef52490c2bb')
    expect(unbonds[0].orchestrator_address).to eq('0xa20416801ac2eacf2372e825b4a90ef52490c2bb')
    expect(unbonds[0].amount).to eq(1000)
    expect(unbonds[0].initialized_at).to eq('2020-03-12 15:28:21')
    expect(unbonds[0].withdraw_round_number).to eq(1683)
    expect(unbonds[0].unbonding_lock_id).to eq(44)

    expect(unbonds[1].transaction_hash).to start_with('0x5cb8eb130c443f36c90b1e27a2f57d0b')
    expect(unbonds[1].round.number).to eq(1663)
    expect(unbonds[1].delegator_address).to eq('0xad0c3f5673c81b890ffb827aa77105e61957a259')
    expect(unbonds[1].orchestrator_address).to eq('0x9c10672cee058fd658103d90872fe431bb6c0afa')
    expect(unbonds[1].amount).to eq(BigDecimal('20.910935050845502725'))
    expect(unbonds[1].initialized_at).to eq('2020-03-13 07:27:55')
    expect(unbonds[1].withdraw_round_number).to eq(1684)
    expect(unbonds[1].unbonding_lock_id).to eq(2)
  end

  it 'synchronizes rebonds' do
    subject.call

    rebonds = chain.rebonds.order(:created_at)

    expect(rebonds.count).to eq(4)

    expect(rebonds[0].transaction_hash).to start_with('0x88a137db80dc62ef423759148a4f09c4')
    expect(rebonds[0].round.number).to eq(1663)
    expect(rebonds[0].delegator_address).to eq('0x5f40189a2349544d4a60e2d433b07db14f67bf79')
    expect(rebonds[0].orchestrator_address).to eq('0xda43d85b8d419a9c51bbf0089c9bd5169c23f2f9')
    expect(rebonds[0].amount).to eq(BigDecimal('2865.967725408334756128'))
    expect(rebonds[0].initialized_at).to eq('2020-03-11 15:48:59')
    expect(rebonds[0].unbonding_lock_id).to eq(0)

    expect(rebonds[1].transaction_hash).to start_with('0x203bee6f5e3abe9f9c6216a276a99663')
    expect(rebonds[1].round.number).to eq(1663)
    expect(rebonds[1].delegator_address).to eq('0xa3a549d8d10d7ef34eaef65377d9ce388369efa3')
    expect(rebonds[1].orchestrator_address).to eq('0x525419ff5707190389bfb5c87c375d710f5fcb0e')
    expect(rebonds[1].amount).to eq(BigDecimal('651.996011695268083230'))
    expect(rebonds[1].initialized_at).to eq('2020-03-13 14:39:08')
    expect(rebonds[1].unbonding_lock_id).to eq(2)
  end

  it 'synchronizes reward cut changes' do
    subject.call

    reward_cut_changes = chain.reward_cut_changes.order(:created_at)

    expect(reward_cut_changes.count).to eq(4)

    expect(reward_cut_changes[0].transaction_hash).to start_with('0xef26f6072653d496bd1804d20f3f4bb2')
    expect(reward_cut_changes[0].round.number).to eq(1663)
    expect(reward_cut_changes[0].orchestrator_address).to eq('0xfb9849b0b53f66b747bfa47396964a3fa22400a0')
    expect(reward_cut_changes[0].reward_cut).to eq(0)
    expect(reward_cut_changes[0].timestamp).to eq('2018-05-01 15:18:17')

    expect(reward_cut_changes[1].transaction_hash).to start_with('0xa523b8d0b98f58e372a79f0d950cb05b')
    expect(reward_cut_changes[1].round.number).to eq(1663)
    expect(reward_cut_changes[1].orchestrator_address).to eq('0x4f4758f7167b18e1f5b3c1a7575e3eb584894dbc')
    expect(reward_cut_changes[1].reward_cut).to eq(50)
    expect(reward_cut_changes[1].timestamp).to eq('2018-05-01 18:09:02')
  end

  it 'synchronizes missed reward calls' do
    subject.call

    missed_reward_calls = chain.missed_reward_calls.order(:created_at)

    expect(missed_reward_calls.count).to eq(4)

    expect(missed_reward_calls[0].transaction_hash).to eq(nil)
    expect(missed_reward_calls[0].round.number).to eq(1663)
    expect(missed_reward_calls[0].orchestrator_address).to eq('0x0119a06b51c83d0eec79708b921a57247dc37e66')
    expect(missed_reward_calls[0].timestamp).to eq('2020-07-29 04:32:49')

    expect(missed_reward_calls[1].transaction_hash).to eq(nil)
    expect(missed_reward_calls[1].round.number).to eq(1663)
    expect(missed_reward_calls[1].orchestrator_address).to eq('0x25c8c5a74ba071c171996047f9613108c7c7767d')
    expect(missed_reward_calls[1].timestamp).to eq('2020-07-29 04:32:49')
  end

  it 'synchronizes deactivations' do
    subject.call

    deactivations = chain.deactivations.order(:created_at)

    expect(deactivations.count).to eq(4)

    expect(deactivations[0].transaction_hash).to start_with('0x85e868394d4d8267801587be56a80092')
    expect(deactivations[0].round.number).to eq(1663)
    expect(deactivations[0].orchestrator_address).to eq('0xe3a5793d7c1d2a04a903fa1695b3e3555d6084ca')
    expect(deactivations[0].timestamp).to eq('2020-01-17 12:54:49')

    expect(deactivations[1].transaction_hash).to start_with('0xfc461f18379d14dd1d000af05f5d1120')
    expect(deactivations[1].round.number).to eq(1663)
    expect(deactivations[1].orchestrator_address).to eq('0xda43d85b8d419a9c51bbf0089c9bd5169c23f2f9')
    expect(deactivations[1].timestamp).to eq('2020-01-21 16:27:53')
  end

  it 'synchronizes slashings' do
    subject.call

    slashings = chain.slashings.order(:created_at)

    expect(slashings.count).to eq(4)

    expect(slashings[0].transaction_hash).to start_with('0x2ec83b1b94367f07fdc2c520a4605801')
    expect(slashings[0].round.number).to eq(1663)
    expect(slashings[0].orchestrator_address).to eq('0xdab934474b870e7bdbf2173204d9e0bd2e745295')
    expect(slashings[0].penalty).to eq(BigDecimal('4.841013947413665910'))
    expect(slashings[0].timestamp).to eq('2020-05-12 21:37:00')

    expect(slashings[1].transaction_hash).to start_with('0xb9c81676be401e39817a05b9cfcd76bf')
    expect(slashings[1].round.number).to eq(1663)
    expect(slashings[1].orchestrator_address).to eq('0x550f67cf2ff8b18f2c8a5c1d74d561bf4cf5cda5')
    expect(slashings[1].penalty).to eq(BigDecimal('55.293050543057421686'))
    expect(slashings[1].timestamp).to eq('2020-07-21 14:16:00')
  end

  it 'synchronizes orchestrators' do
    subject.call

    orchestrators = chain.orchestrators.order(:created_at)

    expect(orchestrators.count).to eq(3)

    expect(orchestrators[0].address).to eq('0x0000000000000000000000000000000000000000')
    expect(orchestrators[0].active).to eq(nil)
    expect(orchestrators[0].reward_cut).to eq(nil)
    expect(orchestrators[0].fee_share).to eq(nil)
    expect(orchestrators[0].total_stake).to eq(0)
    expect(orchestrators[0].name).to eq('Example Orchestrator')
    expect(orchestrators[0].description).to eq('Example Description')
    expect(orchestrators[0].website_url).to eq('http://orchestrator.example')

    expect(orchestrators[1].address).to eq('0x00b1606fc5b771f3079b4fd3ea49e66a2d5fd665')
    expect(orchestrators[1].active).to eq(false)
    expect(orchestrators[1].reward_cut).to eq(10)
    expect(orchestrators[1].fee_share).to eq(5)
    expect(orchestrators[1].total_stake).to eq(BigDecimal('10.429382433426184260'))
    expect(orchestrators[1].name).to eq('Example Orchestrator')
    expect(orchestrators[1].description).to eq('Example Description')
    expect(orchestrators[1].website_url).to eq('http://orchestrator.example')

    expect(orchestrators[2].address).to eq('0x0119a06b51c83d0eec79708b921a57247dc37e66')
    expect(orchestrators[2].active).to eq(true)
    expect(orchestrators[2].reward_cut).to eq(2)
    expect(orchestrators[2].fee_share).to eq(5)
    expect(orchestrators[2].total_stake).to eq(BigDecimal('11949.784949606643635714'))
    expect(orchestrators[2].name).to eq('Example Orchestrator')
    expect(orchestrators[2].description).to eq('Example Description')
    expect(orchestrators[2].website_url).to eq('http://orchestrator.example')
  end

  it 'deletes remaining orchestrators' do
    orchestrators = [
      create_orchestrator(chain, address: '0x00b1606fc5b771f3079b4fd3ea49e66a2d5fd665'),
      create_orchestrator(chain, address: '0x0119a06b51c83d0eec79708b921a57247dc37e66'),
      create_orchestrator(chain, address: '0x7a174e4c95d01dcae6b2df271ba99dce803d8e37')
    ]

    subject.call

    expect(chain.orchestrators.count).to eq(3)

    expect(orchestrators[0].reload).to be_persisted
    expect(orchestrators[1].reload).to be_persisted

    expect { orchestrators[2].reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'synchronizes delegators' do
    subject.call

    delegators = chain.delegators.order(:created_at)

    expect(delegators.count).to eq(2)

    expect(delegators[0].address).to eq('0x000817415963a38c16ba6ccc98f4002684c97697')
    expect(delegators[0].orchestrator_address).to eq('0xa20416801ac2eacf2372e825b4a90ef52490c2bb')
    expect(delegators[0].pending_stake).to eq(BigDecimal('648245.506425693688747163'))

    expect(delegators[1].address).to eq('0x00260ddd1d175bf20c18f1407162db63b840b944')
    expect(delegators[1].orchestrator_address).to eq('0x481efb669b423cfaffa49890205427dea9b3d693')
    expect(delegators[1].pending_stake).to eq(BigDecimal('574149.448538091386387362'))
  end

  it 'deletes remaining delegators' do
    delegators = [
      create_delegator(chain, address: '0x000817415963a38c16ba6ccc98f4002684c97697'),
      create_delegator(chain, address: '0x00260ddd1d175bf20c18f1407162db63b840b944'),
      create_delegator(chain, address: '0x7a174e4c95d01dcae6b2df271ba99dce803d8e37')
    ]

    subject.call

    expect(chain.delegators.count).to eq(2)

    expect(delegators[0].reload).to be_persisted
    expect(delegators[1].reload).to be_persisted

    expect { delegators[2].reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'updates the local height' do
    subject.call
    expect(chain.latest_local_height).to eq(1664)
  end

  it 'updates the synchronization time' do
    freeze_time do
      subject.call
      expect(chain.last_sync_time).to eq(Time.current)
    end
  end
end
