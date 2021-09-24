class Emoney::Validator < ApplicationRecord
  include Cosmoslike::Validatorlike

  scope :active, -> { where.not(current_voting_power: 0) }
end
