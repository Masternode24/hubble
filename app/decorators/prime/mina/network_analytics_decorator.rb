# TODO: Remove these decorator classes as we build out service objects to
# fetch analytics data and populate Prime::Analytics::DataPoint table

class Prime::Mina::NetworkAnalyticsDecorator < Prime::NetworkAnalyticsDecorator
  def total_delegated
    @total_delegated ||= primary_chain.client.validators.sum(&:stake) / (10 ** primary_chain.reward_token_factor)
  end

  def total_figment_delegation
    @figment_delegation_total ||= begin
      delegated_total = 0
      primary_chain.figment_validator_addresses.each do |validator|
        val = primary_chain.client.validator(validator)
        delegated_total += val.validator.stake
      end
      delegated_total / (10 ** primary_chain.reward_token_factor)
    end
  end
end
