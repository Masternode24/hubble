namespace :tweet_events do
  task celo: :environment do
    $stdout.sync = true

    Celo::Chain.enabled.find_each do |chain|
      TaskLock.with_lock!(:sync, "celo-#{chain.slug}") do
        Celo::TweetEventsService.new(chain).call
      end
    end
  end
end
