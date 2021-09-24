require 'rails_helper'

describe Celo::TweetEventsService do
  describe '#call' do
    subject { service.call }

    let(:service) { described_class.new(chain) }
    let(:chain) { create(:celo_chain) }
    let(:client) { double(get_alertable_name: validator_name) }
    let(:paginated_events) do
      Common::PaginatedResponse.new(data: { page: 1, count: 2, pages: 1 },
                                    records: [Celo::EventFactory.generate(event_1, chain),
                                              Celo::EventFactory.generate(event_2, chain)])
    end
    let(:event_1) do
      { 'height' => 3002, 'time' => event_1_time.to_s, 'actor' => validator_name,
        'kind' => 'joined_active_set', 'data' => {} }
    end
    let(:event_2) do
      { 'height' => 3022, 'time' => event_2_time.to_s, 'actor' => validator_name,
        'kind' => 'left_active_set', 'data' => {} }
    end
    let(:validator_name) { '0xD5Fb8A8E6E81BC77d7D807c05b5b8aEAe7c2a458' }
    let(:last_event_tweet_at) { nil }
    let(:event_1_time) { 11.days.ago }
    let(:event_2_time) { 10.days.ago }
    let(:has_twitter_config?) { true }

    before do
      allow(chain).to receive(:client).and_return(client)
      allow(chain).to receive(:has_twitter_config?).and_return(has_twitter_config?)
      allow(client).to receive(:paginated_events).and_return(paginated_events)
      allow_any_instance_of(Router).to receive(:namespaced_path).and_return('path')
    end

    it 'does not tweet old events' do
      expect(service).not_to receive(:tweet)
      subject
    end

    context 'no twitter config' do
      let(:has_twitter_config?) { false }

      it 'does not tweet' do
        expect(service).not_to receive(:tweet)
        subject
      end
    end

    context 'recent events' do
      let(:event_1_time) { 25.seconds.ago }
      let(:event_2_time) { 20.seconds.ago }

      it 'tweets' do
        expect(service).to receive(:tweet).twice
        expect(chain).to receive(:update).twice
        subject
      end
    end
  end
end
