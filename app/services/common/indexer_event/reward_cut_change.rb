class Common::IndexerEvent::RewardCutChange < Common::IndexerEvent
  include ActionView::Helpers::NumberHelper

  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'percentage'
    @from = event['data']['before'].to_f / 1000
    @to = event['data']['after'].to_f / 1000
  end

  def positive?
    to > from
  end

  def twitter_message
    "#{validatorlike_short_name} - commission changed from #{number_to_percentage(from)} to #{number_to_percentage(to)}"
  end
end
