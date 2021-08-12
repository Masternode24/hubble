require 'rails_helper'

RSpec.describe AlertMailer do
  describe '#instant' do
    let(:sub) { create(:alert_subscription, alertable: alertable) }
    let(:events) { create_list(:cosmos_event, 5) }

    let(:email) { AlertMailer.with(sub: sub, events: events).instant }

    context 'with an alertable address' do
      let(:alertable) { create(:alertable_address) }

      it 'sends an instant alert' do
        allow(alertable).to receive(:long_name).and_return('Test')

        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE ALERT - Test on Oasis/OasisChain (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end

    context 'with a delegator list' do
      let(:alertable) { create(:livepeer_delegator_list, name: 'Test') }

      it 'sends an instant alert' do
        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE ALERT - Test on Livepeer/Mainnet (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end

    context 'with an alertable address and Celo events' do
      let!(:alertable) { create(:alertable_address, chain: chain, address: '0x112fF12927CD6f924d80b9Aba32E531733B602fF') }
      let(:chain) { create(:celo_chain) }
      let(:events) { [event_1, event_2, event_3, event_4] }
      let(:event_1) do
        Common::IndexerEvent::ActiveSetInclusion.new({ 'kind' => 'joined_active_set',
                                                       'time' => 1.minute.ago.to_s, 'height' => 22 }, chain)
      end
      let(:event_2) do
        Common::IndexerEvent::NConsecutive.new({ 'kind' => 'missed_n_consecutive',
                                                 'time' => 1.minute.ago.to_s, 'height' => 22, 'data' => { 'threshold' => 10 } }, chain)
      end
      let(:event_3) do
        Common::IndexerEvent::NOfM.new({ 'kind' => 'missed_n_of_m',
                                         'time' => 1.minute.ago.to_s, 'height' => 22, 'data' => { 'threshold' => 10, 'max_validator_sequences' => 100 } }, chain)
      end
      let(:event_4) do
        Common::IndexerEvent::RewardCutChange.new({ 'kind' => 'group_reward_change_1', 'time' => 1.minute.ago.to_s,
                                                    'height' => 22, 'data' => { 'before' => 10, 'after' => 20 },
                                                    'actor' => '0x112fF12927CD6f924d80b9Aba32E531733B602fF' }, chain)
      end

      it 'sends an instant alert' do
        allow(alertable).to receive(:long_name).and_return('Test')

        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE ALERT - Test on Celo/Mainnet (4 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end

    context 'with an alertable address and Avalanche events' do
      let!(:alertable) { create(:alertable_address, chain: chain, address: 'NodeID-NkYLNRp4S6exbWamVvMzUUpXvHeVEzLR6') }
      let(:chain) { create(:avalanche_chain) }
      let(:events) { [event_1, event_2, event_3, event_4] }
      let(:event_1) do
        Common::IndexerEvent::ValidatorAdded.new({ 'type' => 'validator_added',
                                                   'time' => 1.minute.ago.to_s, 'height' => 22 }, chain)
      end
      let(:event_2) do
        Common::IndexerEvent::ValidatorFinished.new({ 'type' => 'validator_finished',
                                                      'time' => 1.minute.ago.to_s, 'height' => 22, 'data' => { 'threshold' => 10 } }, chain)
      end
      let(:event_3) do
        Common::IndexerEvent::DelegatorAdded.new({ 'type' => 'delegator_added',
                                                   'time' => 1.minute.ago.to_s, 'height' => 22 }, chain)
      end
      let(:event_4) do
        Common::IndexerEvent::DelegatorFinished.new({ 'type' => 'delegator_finished',
                                                      'time' => 1.minute.ago.to_s, 'height' => 22 }, chain)
      end

      it 'sends an instant alert' do
        allow(alertable).to receive(:long_name).and_return('Test')

        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE ALERT - Test on Avalanche/Mainnet (4 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end
  end

  describe '#daily' do
    let(:sub) { create(:alert_subscription, alertable: alertable, wants_daily_digest: true) }
    let(:date) { 4.days.ago }
    let(:events) { create_list(:cosmos_event, 5) }

    let(:email) { AlertMailer.with(sub: sub, date: date, events: events).daily }

    context 'with an alertable address' do
      let(:alertable) { create(:alertable_address) }

      it 'sends a daily digest' do
        allow(alertable).to receive(:long_name).and_return('Test')

        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE DAILY DIGEST - Test on Oasis/OasisChain (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end

    context 'with a delegator list' do
      let(:alertable) { create(:livepeer_delegator_list, name: 'Test') }

      it 'sends a daily digest' do
        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE DAILY DIGEST - Test on Livepeer/Mainnet (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end
  end
end
