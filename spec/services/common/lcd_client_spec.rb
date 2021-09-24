require 'rails_helper'

class LcdClientResourceTest < Common::Resource
  field :id
end

describe Common::Client::LcdClient do
  let(:client) { described_class.new('http://indexer') }

  describe '#get' do
    let(:result) { client.get('/endpoint') }

    before do
      stub_request(:get, 'http://indexer/endpoint').to_return(
        status: status,
        body: body
      )
    end

    context 'on success' do
      let(:status) { 200 }
      let(:body)   { JSON.dump(foo: 'bar') }

      it 'returns decoded json data' do
        expect(result).to be_a Hash
        expect(result['foo']).to eq 'bar'
      end
    end

    context 'on bad request' do
      let(:status) { 400 }
      let(:body)   { JSON.dump(error: 'invalid request') }

      it 'raises an error' do
        expect { result }.to raise_error(Common::LcdClient::Error)
      end
    end
  end
end
