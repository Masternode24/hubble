class AlertableAddress < ApplicationRecord
  belongs_to :chain, polymorphic: true
  has_many :alert_subscriptions, as: :alertable, dependent: :delete_all

  alias_attribute :name_and_owner, :address

  delegate :validator_event_defs, to: :chain

  FULL_LENGTH_NETWORK_NAMES = %w[NEAR Avalanche].freeze

  def to_param
    address
  end

  def destroy_if_orphaned
    destroy unless alert_subscriptions.any?
  end

  def long_name
    chain.get_alertable_name(address)
  end

  # Skale doesn't pass the validator name through the event, only the validator ID
  # so we use an indexer call to get the validator name directly. In the future this
  # should be refactored so we can pass through an address into this in future or
  # perhaps use a decorator or similar
  def short_name(max_length = 16)
    if FULL_LENGTH_NETWORK_NAMES.include?(chain.network_name)
      long_name
    elsif chain.network_name == 'Skale'
      chain.client.validator(long_name).name
    else
      long_name.truncate(max_length)
    end
  end

  def recent_events(event_kind, after_time)
    chain.get_recent_events(chain, address, event_kind, after_time)
  end
end
