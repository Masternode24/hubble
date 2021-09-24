class Admin::Crypto::ChainsController < Admin::Cosmoslike::ChainsController
  prepend_before_action -> { @namespace = ::Crypto }
end
