class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user = tweet.twitter_user

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = API_KEYS["consumer_key"]
      config.consumer_secret     = API_KEYS["consumer_secret"]
      config.access_token        = user.access_token
      config.access_token_secret = user.access_token_secret
    end

    client.update(tweet.text)

    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here
  end
end