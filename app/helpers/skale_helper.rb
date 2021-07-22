module SkaleHelper
  def skale_chain_dashboard_path(*_args)
    skale_root_path
  end

  def node_visible?(status)
    visible = %w[Active In_Maintenance]
    visible.include?(status)
  end

  def format_skale_event_data(event, validators, full_account: false)
    case event.kind
    when 'new_delegation'
      "#{account_lookup(event.sender, full_account)} submitted their Delegation to #{validator_lookup(event.recipient_id, validators)}"
    when 'delegation_accepted'
      "#{validator_lookup(event.sender_id, validators)} Accepted A Delegation from #{account_lookup(event.recipient, full_account)}"
    when 'delegation_rejected'
      "#{validator_lookup(event.recipient_id, validators)} Rejected A Delegation from #{account_lookup(event.sender, full_account)}"
    when 'undelegation_requested'
      "#{account_lookup(event.sender, full_account)} requested undelegation from #{validator_lookup(event.recipient_id, validators)}"
    when 'joined_active_set'
      "#{validator_lookup(event.recipient_id, validators)} joined the active set of validators"
    when 'left_active_set'
      "#{validator_lookup(event.recipient_id, validators)} left the active set of validators"
    when 'mdr_change'
      # no sender or receiver data available
      ' Minimum delegation rate was changed'
    when 'fee_change'
      # no sender or receiver data available
      ' fee was changed'
    when 'slashed'
      # no sender or receiver data available
      ' was slashed'
    when 'forgiven'
      # no examples of this yet
      ' was forgiven'
    else
      ' '
    end
  end

  def validator_lookup(id, validators)
    validator = validators.select { |v| v.id == id }[0]
    link_to(validator.name, skale_chain_validator_path(@chain, validator.id))
  end

  def account_lookup(account, full_account)
    account = full_account ? account : account.truncate(10)
    link_to(account, skale_chain_account_path(@chain, account))
  end
end
