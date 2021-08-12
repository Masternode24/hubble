require 'rails_helper'

describe Avalanche::Client do
  let(:indexer_endpoint) { 'http://avalanche-indexer' }
  let(:indexer_name)     { 'avalanche' }
  let(:client)           { described_class.new(indexer_endpoint) }

  before do
    stub_endpoint('/status', {}, 'status')
    stub_endpoint('/validators', {}, 'validators')
    stub_endpoint('/network_stats', {}, 'network_stats')
    stub_endpoint('/address/id', {}, 'accounts')
    stub_endpoint('/delegations', {}, 'delegations')
    stub_endpoint('/transactions/id', {}, 'transactions')
    stub_endpoint('/assets', {}, 'assets')
    stub_endpoint('/chains', {}, 'chains')
    stub_endpoint('/events/id', {}, 'events')
  end

  describe '#status' do
    let(:result) { client.status }

    it 'returns Health successful' do
      expect(result).to be_a Avalanche::Status
    end
  end

  describe '#validators' do
    let(:result) { client.validators }

    it 'returns validators' do
      expect(result).to be_a Array
      expect(result.first).to be_a Avalanche::Validator
    end
  end

  describe '#network_stats' do
    let(:result) { client.network_stats }

    it 'returns network status' do
      expect(result).to be_a Array
      expect(result.first).to be_a Avalanche::NetworkStat
    end
  end

  describe '#account' do
    let(:result) { client.account('id') }

    it 'returns accounts' do
      expect(result).to be_a Avalanche::Account
    end
  end

  describe '#delegations' do
    let(:result) { client.delegations }

    it 'returns delegations' do
      expect(result).to be_a Array
      expect(result.first).to be_a Avalanche::Delegation
    end
  end

  describe '#transaction' do
    let(:result) { client.transaction('id') }

    it 'returns transaction' do
      expect(result).to be_a Avalanche::Transaction
    end
  end

  describe '#assets' do
    let(:result) { client.assets }

    it 'returns assets' do
      expect(result).to be_a Array
      expect(result.first).to be_a Avalanche::Asset
    end
  end

  describe '#blockchains' do
    let(:result) { client.blockchains }

    it 'returns blockchains' do
      expect(result).to be_a Array
      expect(result.first).to be_a Avalanche::BlockChain
    end
  end

  describe '#events' do
    let(:result) { client.event('id') }

    it 'returns events' do
      expect(result).to be_a Avalanche::Event
    end
  end
end
