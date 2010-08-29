#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require 'cinch'

module LibScosugBot
  module Bot
    include LibScosugBot::Views

    def self.setup(irc_host, irc_nick, irc_channels, db)
      irc_bot = Cinch::Bot.new do
        configure do |c|
          c.server = irc_host
          c.nick = irc_nick
          c.channels = irc_channels
        end

        on :message, 'hello' do |m|
          m.reply "Greetings, Program!", m.user.nick
        end

        on :message, /say (.+)/ do |m, text|
          m.reply text
        end

        on :message, /robe/ do |m|
          m.reply "#{m.user.nick}: I put on my robe and wizard hat."
        end

        on :message, /yfi (.+)/ do |m, whatever|
          abbrevs = :whatever.split.collect do |w|
            w[0].chr
          end
          m.reply "yfi#{abbrevs.join}!"
        end

        on :message, 'ls' do |m|
          m.reply "This isn't your shell, buddy. Take it somewhere else!", m.user.nick
        end

        on :message, "ping" do |m|
          db.log(0, "ping from #{m.nick}", 'ping')
          m.reply "pong -> [#{Time.now.utc}]", m.user.nick
        end

        on :message, "fortune" do |m|
          m.reply "#{`fortune -s`}".gsub(/\n/, ' ').gsub(/\t/, ' ')
        end
        
        on :message, "language"  do |m|
          m.reply "I am written in Ruby using Cinch. Check it out on github -> http://github.com/injekt/cinch", m.user.nick
        end
        
        on :message, "you suck", :prefix => :bot do |m|
          m.reply "I will go to the animal shelter and find the saddest, cutest kitten there. I will buy you this kitten. You will fall in love with this kitten. And then, in the middle of the night, I will sneak into your house and I will punch you in the face.", m.user.nick
        end

        on :message, "pull my finger", :use_prefix => :bot do |m|
          m.reply "get away from me. you. sick. fuck.", m.user.nick
        end

        on :message, /^!lastlog$/, :use_prefix => true do |m|
          m.reply db.last_log_message
        end

        started = Time.now
        on :message, /^!stats$/, :use_prefix => true do |m|
          m.reply "Up since #{started}"
          m.reply "#{db.definition_count} total definitions"
          m.reply "#{db.log_count} total log entries"
        end
      
        on :message, 'joke', :use_prefix => true do |m|
          m.reply 'Ba-DUM Tish!'
        end

      end
      # return bot object
      irc_bot
    end

    def self.plugins(bot, db)
      bot.plugin "memorize :thing is :def" do |m|
        m.reply MemorizationSnippets.memorize_snippet(m.args[:thing], 
                                                      db.memorize(m.args[:thing].downcase, m.args[:def]))
      end
      
      bot.plugin "recall :thing" do |m|
        m.reply MemorizationSnippets.recall_snippet(m.args[:thing], db.recall(m.args[:thing].downcase))
      end
      
      bot.plugin("tell :who-word about :what") do |m|
        definition = MemorizationSnippets.recall_snippet(m.args[:what], db.recall(m.args[:what]))
        m.reply "#{m.args[:who]}: #{definition}"
      end

      bot.plugin(",:thing", :prefix => false) do |m|
        m.reply MemorizationSnippets.recall_snippet(m.args[:thing], db.recall(m.args[:thing].downcase))
      end

      bot.plugin("forget :thing") do |m|
        if db.forget(m.args[:thing].downcase)
          rep = "Forgot #{m.args[:thing]}"
        else
          rep = "Could not forget #{m.args[:thing]}. Was it ever defined?" 
        end
        m.reply rep
      end

      bot.plugin 'twitter :nick' do |m|
        nick = m.args[:nick]
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
end
