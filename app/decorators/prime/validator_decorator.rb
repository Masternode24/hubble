class Prime::ValidatorDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def initialize(validator, network = nil)
    super(validator)
    @network = network || validator.network
  end

  # TO DO: Need reward rate from indexer
  def reward_rate_as_percentage
    'N/A'
  end
end
