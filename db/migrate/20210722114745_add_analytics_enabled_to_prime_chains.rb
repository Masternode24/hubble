class AddAnalyticsEnabledToPrimeChains < ActiveRecord::Migration[5.2]
  def change
    add_column :prime_chains, :analytics_enabled, :boolean, default: false
  end
end
