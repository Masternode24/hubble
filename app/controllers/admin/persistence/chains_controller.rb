class Admin::Persistence::ChainsController < Admin::Cosmoslike::ChainsController
  prepend_before_action -> { @namespace = ::Persistence }
end
