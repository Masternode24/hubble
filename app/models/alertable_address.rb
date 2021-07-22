class AlertableAddress < ApplicationRecord
  belongs_to :chain, polymorphic: true
  has_many :alert_subscriptions, as: :alertable, dependent: :delete_all

  alias_attribute :name_and_owner, :address

  delegate :validator_event_defs, to: :chain

  def to_param
    address
  end

  def destroy_if_orphaned
    destroy unless alert_subscriptions.any?
  end

  def long_name
    if chain.respond_to?(:client)
      chain.client.get_alertable_name(address)
    else
      chain.get_alertable_name(address)
    end
  end

  def short_name(max_length = 16)
    if chain.network_name == 'NEAR'
      long_name
    else
      long_name.truncate(max_length)
    end
  end

  def recent_events(klass, time_ago)
    if chain.respond_to?(:client)
      chain.client.get_recent_events(chain, address, klass, time_ago)
    else
      chain.get_recent_events(address, klass, time_ago)
    end
  end
end
