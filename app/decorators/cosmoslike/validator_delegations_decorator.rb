class Cosmoslike::ValidatorDelegationsDecorator
  include FormattingHelper

  DEFAULT_VALIDATOR_DELEGATIONS_PAGE = 1
  DEFAULT_DELEGATIONS_LIMIT = 20

  delegate :empty?, to: :delegations

  def initialize(chain, validator, page)
    @chain = chain
    @namespace = chain.class.name.deconstantize.constantize
    @validator = validator
    @page = page
  end

  def error?
    delegations.nil?
  end

  def delegations
    @delegations ||= fetch_delegations
  end

  def limit
    DEFAULT_DELEGATIONS_LIMIT
  end

  def page
    @page ||= DEFAULT_VALIDATOR_DELEGATIONS_PAGE
  end

  def offset
    page.to_i > 1 ? ((page.to_i - 1) * limit) : 0
  end

  protected

  def fetch_delegations
    decorated_delegations = []
    if @validator.owner.nil?
      return nil
    end

    decorated_delegations.concat(validator_delegations.map do |delegation|
                                   decorate_delegation(delegation)
                                 end)
    decorated_delegations.concat(unbondings.map { |delegation| decorate_unbonding(delegation) })
    return decorated_delegations
  rescue @chain.namespace::SyncBase::CriticalError
    return nil
  end

  def validator_delegations
    Rails.cache.fetch("#{@chain.slug}/#{@validator.id}/validator_delegations", expires_in: 1.day) do
      @chain.syncer(30000).get_validator_delegations(@validator.owner, params = { 'pagination.offset': offset, 'pagination.limit': limit })
    end
  end

  def unbondings
    Rails.cache.fetch("#{@chain.slug}/#{@validator.id}/unbondings", expires_in: 1.day) do
      @chain.syncer.get_validator_unbonding_delegations(@validator.owner)
    end
  end

  def decorate_delegation(delegation)
    delegation = delegation['shares'] ? delegation : delegation['delegation']
    tokens = (delegation['shares'].to_f / @validator.info_field('delegator_shares').to_f) * @validator.info_field('tokens').to_f
    {
      account: delegation['delegator_address'],
      validator: @chain.accounts.select do |account|
                   account.address == delegation['delegator_address']
                 end                 .try(:validator),
      amount: tokens * (10 ** -@chain.token_map[@chain.primary_token]['factor']),
      share: (delegation['shares'].to_f / @validator.info_field('delegator_shares').to_f) * 100,
      status: 'bonded'
    }
  end

  def decorate_unbonding(unbonding)
    {
      account: unbonding['delegator_address'],
      validator: @chain.accounts.select do |account|
                   account.address == unbonding['delegator_address']
                 end                 .try(:validator),
      amount: unbonding['entries'].inject(0) { |acc, e| acc + e['balance'].to_f },
      status: 'unbonding'
    }
  end
end
