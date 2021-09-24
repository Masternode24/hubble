module Prime::StakingHelper
  def beaconscan_validator_link(validator)
    link_to(truncate(validator.pubkey), "https://beaconscan.com/validator/0x#{validator.pubkey}", target: '_blank', rel: 'noopener')
  end
end
