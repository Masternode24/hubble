module AvalancheHelper
  SEARCH_INCLUDE_OPTIONS = [
    ['', 'Everything'],
    %w[sent Sent],
    %w[received Received]
  ].freeze

  def ava_tx_include_opts
    SEARCH_INCLUDE_OPTIONS
  end

  def remaining_time(time)
    time_ago_in_words(time).split(',').first.split(' and ').first
  end

  def capacity_remaining(capacity_percent)
    (100 - capacity_percent).round(2)
  end

  def format_avalanche_event_data(event)
    case event.type
    when 'delegator_added'
      "New Delegation Added to #{formatted_validator_link(event)}"
    when 'delegator_finished'
      "Delegation Finished for #{formatted_validator_link(event)}"
    when 'validator_added'
      "Validator #{formatted_validator_link(event)} began staking"
    when 'validator_finished'
      "Validator #{formatted_validator_link(event)} finished staking"
    when 'validator_commission_changed'
      "Validator #{formatted_validator_link(event)} changed their Delegation Fee to #{event.data['after']}%"
    when 'subnet_validator_added'
      "Subnet Validator was added by #{formatted_validator_link(event)}"
    else
      "#{event.type.humanize} for #{formatted_validator_link(event)}"
    end
  end

  def formatted_validator_link(event)
    link_to 'NodeID-' + event.item_id.truncate(15), avalanche_chain_validator_path(@chain, 'NodeID-' + event.item_id)
  end
end
