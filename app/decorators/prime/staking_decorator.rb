class Prime::StakingDecorator < SimpleDelegator
  def positions
    self[:positions]
  end

  def total_amount
    @total_amount ||= positions.sum(&:staked_eth_amount)
  end

  def validators_count
    @validators_count ||= positions.sum { |pos| pos.validators.size }
  end
end
