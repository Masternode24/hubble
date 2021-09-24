namespace :analytics do
  task fetch: :environment do
    Prime::Network.analytics_enabled.each do |network|
      klass = "Prime::Analytics::#{network.name.capitalize}".safe_constantize
      klass&.new(network)
    end
  end
end
