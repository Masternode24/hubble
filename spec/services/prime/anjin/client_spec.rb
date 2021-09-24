require 'rails_helper'

describe Prime::Anjin::Client do
  let(:endpoint) { 'http://internal-anjin/api/v1' }
  let(:client) { described_class.new(endpoint) }

  describe '#customers' do
    let(:result) { client.customers }

    before do
      stub_request(:get, "#{endpoint}/customers").
        to_return(
          status: 200,
          body: file_fixture('prime/anjin/customers.json').read
        )
    end

    it 'returns customers records' do
      expect(result).to be_an Array
      expect(result.first).to be_a Prime::Anjin::Customer
    end
  end

  describe '#customer' do
    context 'bad id' do
      before do
        stub_request(:get, "#{endpoint}/customers/ID").
          to_return(status: 404)
      end

      it 'raises an error' do
        expect { client.customer('ID') }.
          to raise_error Common::Client::NotFoundError, '404 Not Found'
      end
    end

    context 'good id' do
      before do
        stub_request(:get, "#{endpoint}/customers/ID").
          to_return(
            status: 200,
            body: file_fixture('prime/anjin/customer.json').read
          )
      end

      it 'returns customer record' do
        expect(client.customer('ID')).to be_a Prime::Anjin::Customer
      end
    end
  end

  describe '#staking_positions' do
    let(:result) { client.staking_positions }

    before do
      stub_request(:get, "#{endpoint}/staking/eth2/staking_positions?include=eth2_validators").
        to_return(
          status: 200,
          body: file_fixture('prime/anjin/staking_positions.json').read
        )

      stub_request(:get, "#{endpoint}/staking/eth2/staking_positions?filter%5Bcustomer_id_eq%5D=CUSTOMER&include=eth2_validators").
        to_return(
          status: 200,
          body: file_fixture('prime/anjin/staking_positions.json').read
        )
    end

    it 'returns all staking positions' do
      expect(result).to be_an Array
      expect(result.first).to be_a Prime::Anjin::StakingPosition
    end

    context 'with customer filter' do
      let(:result) { client.staking_positions(customer_id: 'CUSTOMER') }

      it 'filters by customer' do
        expect(result.size).to eq 8
      end
    end
  end

  describe '#validators' do
    let(:result) { client.validators }

    before do
      stub_request(:get, "#{endpoint}/staking/eth2/validators").
        to_return(
          status: 200,
          body: file_fixture('prime/anjin/validators.json').read
        )
    end

    it 'returns all validators' do
      expect(result).to be_an Array
      expect(result.first).to be_a Prime::Anjin::Validator
    end
  end
end
