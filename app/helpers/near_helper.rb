module NearHelper
  def near_epoch_efficiency_color(efficiency)
    case efficiency
    when 0..90
      'text-danger'
    when 90..97
      'text-warning'
    else
      ''
    end
  end

  def format_date(created_at)
    "#{created_at.to_date.strftime('%B %d, %Y')} #{created_at.to_time.strftime('at %H:%M %Z')}"
  end

  def format_event_data(event)
    case event.action
    when 'joined_active_set'
      ' joined the active set of validators'
    when 'left_active_set'
      ' left the active set of validators'
    when 'kicked'
      reason = kicked_reason(event.metadata['reason'])
      " was kicked - reason: #{reason}"
    # we currently haven't seen this in production so its hard to see what this will look like
    when 'balance_changed'
      ' had a balance change'
    else
      ' '
    end
  end

  def reward_fee_helper(reward_fee)
    reward_fee ? "#{reward_fee}%" : 'Not available'
  end

  private

  def kicked_reason(reason)
    case reason
    when 'unstaked'
      'Validator unstaked'
    when 'slashed'
      'Validator was slashed'
    when 'no_seat'
      'Did not get a seat'
    when 'not_enough_blocks'
      'Not enough blocks'
    when 'not_enough_chunks'
      'Not enough chunks'
    when 'not_enough_stake'
      'Not enough staked'
    else
      'Reason not available'
    end
  end
end
