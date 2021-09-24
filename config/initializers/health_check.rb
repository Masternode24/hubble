HealthCheck.setup do |config|
  config.uri = 'health'
  config.success = 'ok'
  config.standard_checks = %w[database migrations cache sidekiq-redis-if-present]
  config.full_checks = config.standard_checks
end
