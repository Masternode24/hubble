# TODO: Remove these decorator classes as we build out service objects to
# fetch analytics data and populate Prime::Analytics::DataPoint table

class Prime::Terra::NetworkAnalyticsDecorator < Prime::NetworkAnalyticsDecorator
  def total_delegated
    @total_delegated ||= begin
      chain = Terra::Chain.primary
      chain.staked_amount / (10 ** chain.token_map[chain.primary_token]['factor'])
    end
  end

  def total_figment_delegation
    @figment_delegation_total ||= begin
      delegated_total = 0
      primary_chain.figment_validator_addresses.each do |validator|
        delegated_total += Terra::Chain.primary.validators.find_by(address: validator).current_voting_power
      end
      delegated_total
    end
  end
end
