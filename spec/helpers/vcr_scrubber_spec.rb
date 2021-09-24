require 'rails_helper'

describe VcrScrubber do
  let(:config) { instance_double(VCR::Configuration) }

  let(:secrets) do
    {
      api_key: 'API_KEY',
      api_secret: 'API_SECRET',
      public_endpoint: 'https://public-endpoint.com',
      private_endpoint: 'http://localhost',
      notification_webhook: 'https://slack.com/webhook/dummy',
      nested: {
        token: 'API_TOKEN'
      }
    }
  end

  let(:filtered) { [] }

  before do
    allow(config).to receive(:filter_sensitive_data) do |_, _, &block|
      filtered << block.call
    end
  end

  describe '.configure' do
    before do
      described_class.configure(config, secrets)
    end

    it 'enables sensitive data filtering' do
      expect(config).to have_received(:filter_sensitive_data).exactly(4).times
      expect(filtered).to eq [
        secrets[:api_key],
        secrets[:api_secret],
        secrets[:notification_webhook],
        secrets[:nested][:token]
      ]
    end
  end
end
