#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require 'cinch'

module LibScosugBot
  module Bot
    def self.setup(irc_host, irc_nick, irc_channels, db)
      irc_bot = Cinch::Bot.new do
        configure do |c|
          c.server = irc_host
          c.nick = irc_nick
          c.channels = irc_channels
          c.plugins.plugins = [::LibScosugBot::TwitterPlugin, ::LibScosugBot::MemorizationPlugin]
        end

        on :message, /^hello$/ do |m|
          m.reply "Greetings, Program!", m.user.nick
        end

        on :message, /why\?/ do |m|
          m.reply "Why not?"
        end

        on :message, /^!say (.+)$/ do |m, text|
          m.reply text
        end

        on :message, /robe/ do |m|
          m.reply "#{m.user.nick}: I put on my robe and wizard hat."
        end

        on :message, /^!yfi (.+)/ do |m, whatever|
          abbrevs = whatever.split.collect do |w|
            w[0].chr
          end
          m.reply "yfi#{abbrevs.join}!"
        end

        on :message, /^ls (.+)$/ do |m|
          m.reply "This isn't your shell, buddy. Take it somewhere else!", m.user.nick
        end

        on :message, /^!ping$/ do |m|
          db.log(0, "ping from #{m.user.nick}", 'ping')
          m.reply "pong -> [#{Time.now.utc}]", m.user.nick
        end

        on :message, /^!fortune$/ do |m|
          m.reply "#{`fortune -s`}".gsub(/\n/, ' ').gsub(/\t/, ' ')
        end
        
        on :message, /^!language$/  do |m|
          m.reply "I am written in Ruby using Cinch. Check it out on github -> http://github.com/injekt/cinch", m.user.nick
        end
        
        on :message, "you suck" do |m|
          m.reply "I will go to the animal shelter and find the saddest, cutest kitten there. I will buy you this kitten. You will fall in love with this kitten. And then, in the middle of the night, I will sneak into your house and I will punch you in the face.", m.user.nick
        end

        on :message, "pull my finger" do |m|
          m.reply "get away from me. you. sick. fuck.", m.user.nick
        end

        on :message, /^!lastlog$/ do |m|
          m.reply db.last_log_message
        end

        started = Time.now
        on :message, /^!stats$/, :use_prefix => true do |m|
          m.reply "Up since #{started}"
          m.reply "#{db.definition_count} total definitions"
          m.reply "#{db.log_count} total log entries"
        end
      
        on :message, /^!joke$/ do |m|
          m.reply 'Ba-DUM Tish!'
        end

      end
      # return bot object
      irc_bot
    end
  end
end
