module Prime
  class Reward::Near < Prime::Reward
    field :time, type: :timestamp
    field :amount, type: :integer

    def initialize(attr, account, token_factor: nil, token_display: nil)
      super(attr, account, token_factor: token_factor, token_display: token_display)
      @time = Time.zone.parse(attr['interval'])
      @amount = attr['amount'].to_i
      @validator_address = attr['validator']
    end
  end
end
