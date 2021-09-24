require 'rails_helper'

describe Prime::ApplicationHelper do
  it 'has defaults' do
    expect(described_class::PAGE_TITLE_PREFIX).to eq 'Prime by Figment'
    expect(described_class::NETWORK_EVENTS_LIMIT).to eq 25
  end

  describe '#network_events' do
    context 'no enabled networks' do
      it 'returns an empty array' do
        expect(network_events).to eq []
      end
    end

    context 'with enabled networks' do
      let(:polkadot) { create(:prime_network, name: 'Polkadot') }
      let(:oasis) { create(:prime_network, name: 'Oasis') }
      let!(:near) { create(:prime_network, name: 'Near') }

      let!(:polkadot_chain) do
        create(:prime_chain,
               network: polkadot,
               name: 'Polkadot',
               slug: 'polkadot',
               api_url: 'http://localhost:2222')
      end

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

      let!(:near_chain) do
        create(:prime_chain,
               network: near,
               name: 'Mainnet',
               slug: 'mainnet',
               type: 'Prime::Chains::Near',
               api_url: 'https://localhost:3333',
               reward_token_factor: 24,
               reward_token_remote: 'near',
               reward_token_display: 'NEAR')
      end

      before do
        allow_any_instance_of(Prime::Network).to receive(:events!) do |network|
          (1..10).map do |i|
            data = {
              'resources' => [{ 'link' => 'link' }],
              'createDate' => (Time.current - i.seconds).to_s,
              'updateDate' => (Time.current - i.seconds).to_s
            }

            Prime::NetworkEventDecorator.new(
              Prime::NetworkEvent.new(data, network)
            )
          end
        end
      end

      it 'returns network events' do
        expect(network_events.size).to eq described_class::NETWORK_EVENTS_LIMIT
        expect(network_events.map { |event| event.network.name }.uniq.sort).to eq %w[near oasis polkadot]
      end
    end
  end
end
