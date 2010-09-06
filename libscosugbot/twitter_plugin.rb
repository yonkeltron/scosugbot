require 'cinch'

module LibScosugBot
  class TwitterPlugin
    include ::Cinch::Plugin

    match /twitter (\S+)$/
    prefix '!'

    def execute(m, nick)
      db = DATABASE
      m.reply "Fetching last tweet for #{nick}..."
      db.log(2, "Fetching tweets for #{nick}", 'twitter')
      begin
        LibScosugBot::Utils::Twitter.get_last_twitter_statuses(nick).each do |tweet|
          m.reply "#{nick} tweeted \"#{tweet['text']}\" at #{tweet['created_at']}"
        end
      rescue Exception => e
        message = "Error fetching tweets: #{e}"
        db.log(5, message)
        m.reply message
      end
    end
  end
end
