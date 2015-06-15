class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def tweet(status)
    tweet = tweets.create!(text: status)
    TweetWorker.perform_async(tweet.id)
  end

  def fetch_tweets!
    @user_timeline = $client.user_timeline(self.username).first(10)
    @user_timeline.each do |x|
      Tweet.create(text: x.text, twitter_user_id: self.id)
    end
    @user_timeline
  end

  def tweets_stale?
    if self.tweets.first.stale?
      if ($client.user_timeline(self.username).first.created_at > self.tweets.first.created_at)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def generate_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["consumer_key"]
      config.consumer_secret     = ENV["consumer_secret"]
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end
end





