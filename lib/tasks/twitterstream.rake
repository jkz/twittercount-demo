namespace :twitter do
  desc "Track a keyword"
  task track: :environment do

    puts "- Configure"

    TweetStream.configure do |config|
      config.consumer_key       = ''
      config.consumer_secret    = ''
      config.oauth_token        = ''
      config.oauth_token_secret = ''
      config.auth_method        = :oauth
    end


    pubnub = Pubnub.new(
        :publish_key   => '', # publish_key only required if publishing.
        :subscribe_key => '', # required
        :secret_key    => '', # optional, if used, message signing is enabled
        :cipher_key    => nil,    # optional, if used, encryption is enabled
        :ssl           => nil     # true or default is false
    )

    @my_callback = lambda { |message| puts(message) }

    puts "- Connect"

    ActiveRecord::Base.connection.reconnect!

    puts "- Log"
    ActiveRecord::Base.logger = Logger.new(File.open('log/stream.log', 'w+'))

    puts "- Stream"

    client = TweetStream::Client.new

    puts client

    Tweet.delete_all

    pubnub.publish(
      :channel  => :gamaroffxjtg,
      :message  => {current: 0, target: 10}.to_json,
      :callback => @my_callback
    )

    # Use 'track' to track a list of single-word keywords
    client.track('#HipHop', '#pizza') do |status|
      puts "<DATA>"
      #puts status.text
      #Status.create_from_tweet(status)
      tweet = Tweet.create(uid: status.id, user: status.from_user_name, text: status.text)
      tweet.save

      count = Tweet.all.count

      pubnub.publish(
        :channel  => :gamaroffxjtg,
        :message  => {current: count, target: 10}.to_json,
        :callback => @my_callback
      )

      puts "</DATA>"

    end
  end
end

=begin
    daemon = TweetStream::Daemon.new('tracker', :log_output => true)
    daemon.on_inited do
      ActiveRecord::Base.connection.reconnect!
      ActiveRecord::Base.logger = Logger.new(File.open('log/stream.log', 'w+'))
    end
    daemon.track('#jessethegame', '#pizza') do |tweet|
      Status.create_from_tweet(tweet)
      end
  end
=end
