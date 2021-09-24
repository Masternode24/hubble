require 'rails_helper'

describe Common::AlertSubscriptionNotifier do
  describe '#run!' do
    subject { described_class.new(type).run! }

    let(:type) { :instant }
    let!(:alert_subscription) do
      create(:alert_subscription, alertable: alertable, last_instant_at: 20.minutes.ago,
                                  event_kinds: %w[active_set_inclusion])
    end
    let(:alertable) { create(:alertable_address, chain: chain, address: '0x112fF12927CD6f924d80b9Aba32E531733B602fF') }
    let(:chain) { create(:celo_chain) }
    let(:mailer_double) { double(instant: double(deliver_now: nil)) }
    let(:validator_events) { [event] }
    let(:event) { { 'kind' => 'joined_active_set', 'time' => Time.now.to_s } }

    before do
      allow_any_instance_of(Celo::Client).to receive(:fetch_events).and_return(validator_events)
    end

    it 'sends alert email with events' do
      expect(AlertMailer).to receive(:with).and_return(mailer_double)
      subject
    end

    context 'for older events' do
      let(:event) { { 'kind' => 'joined_active_set', 'time' => 30.minutes.ago.to_s } }

      it 'does not send alert email' do
        expect(AlertMailer).not_to receive(:with)
        subject
      end
    end

    context 'for events not subscribed to' do
      let(:event) do
        { 'kind' => 'group_reward_change_3', 'data' => { 'before' => '10', 'after' => '20' },
          'time' => Time.now.to_s }
      end

      it 'does not send alert email' do
        expect(AlertMailer).not_to receive(:with)
        subject
      end
    end
  end
end
