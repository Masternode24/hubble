require 'rails_helper'

RSpec.describe Persistence::Chain do
  let!(:chains) { create_list(:persistence_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
