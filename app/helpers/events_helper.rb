module EventsHelper
  def get_icon_class(event)
    return "fa fa-#{event.icon_name} text-#{event.positive? ? 'success' : 'danger'}"
  end

  def event_kind_to_name(kind)
    case kind
    when 'voting_power_change' then 'Voting Power Change %'
    when 'active_set_inclusion' then 'Joined/Left the Active Set'
    when 'n_of_m' then 'Misses N of Last M Precommits'
    when 'n_consecutive' then 'Misses N Consecutive Precommits'
    when 'balance_change' then 'Balance Change %'
    when 'kicked' then 'Was Kicked'
    when 'validator_added' then 'New Validator Added'
    when 'validator_finished' then 'Validator Finished'
    when 'delegator_added' then 'New Delegation Added'
    when 'delegator_finished' then 'Delegation Finished'
    when 'validator_commission_changed' then 'Validator Commission Changed'
    else kind.titlecase
    end
  end

  def event_kind_types(event_classes)
    event_classes.map do |kind_class|
      kind_class.name.split('::').last.underscore
    end
  end

  def to_partial_path(event)
    "/common/validator_events/#{event.kind_class}"
  end
end
