class Crypto::DashboardController < Common::DashboardController
  prepend_before_action -> { @namespace = self.class.name.split('::').first.constantize }
end
