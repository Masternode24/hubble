class AddSpecsToPrimeAnalytics < ActiveRecord::Migration[5.2]
  def change
    add_column :prime_analytics_data_points, :figment_commission_rate, :float
    add_column :prime_analytics_data_points, :figment_effective_rate, :float
    add_column :prime_analytics_data_points, :investor_rewards_net_apr, :float
    add_column :prime_analytics_data_points, :figment_daily_commission, :float
  end
end
