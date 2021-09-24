class IndexDataPointsTime < ActiveRecord::Migration[5.2]
  # Block Range Interval index (brin)
  # https://aws.amazon.com/blogs/database/designing-high-performance-time-series-data-tables-on-amazon-rds-for-postgresql/
  def change
    add_index :prime_analytics_data_points, :date, using: 'brin'
  end
end
