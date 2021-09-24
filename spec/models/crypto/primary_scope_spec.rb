require 'rails_helper'

RSpec.describe Crypto::Chain do
  let!(:chains) { create_list(:crypto_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
