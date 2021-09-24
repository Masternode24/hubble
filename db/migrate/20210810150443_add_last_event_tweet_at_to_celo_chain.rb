class AddLastEventTweetAtToCeloChain < ActiveRecord::Migration[5.2]
  def change
    add_column :celo_chains, :last_event_tweet_at, :datetime
  end
end
