#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require 'cinch'

module LibScosugBot
  module Bot
    include LibScosugBot::Views

    def self.setup(irc_host, irc_nick, irc_channels, storage_system)
      irc_bot = Cinch.setup do
        server irc_host
        nick irc_nick
        channels irc_channels
      end
      self.plugins(irc_bot, storage_system)
      irc_bot
    end

    def self.plugins(bot, db)
      bot.plugin("hello", :prefix => :bot) do |m|
        m.answer "man, fuck you. leave my silicon ass alone!"
      end

      bot.plugin "say :text" do |m|
        m.reply m.args[:text]
      end

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

      bot.plugin "yfi :whatever" do |m|
        abbrevs = m.args[:whatever].split.collect do |w|
          w[0].chr
        end
        m.reply "yfi#{abbrevs.join}!"
      end

      bot.add_custom_pattern(:swear, /fuck|shit/)

      bot.plugin(":curse-swear", :prefix => false) do |m|
        m.answer "watch your fucking mouth for saying #{m.args[:curse]}..."
      end

      bot.plugin("robe", :prefix => false) do |m|
        m.reply "#{m.nick}: I put on my robe and wizard hat."
      end

      bot.plugin("ping") do |m|
        db.log(0, "ping from #{m.nick}", 'ping')
        m.answer "pong -> [#{Time.now.utc}]"
      end

      bot.plugin "fortune" do |m|
        m.reply "#{`fortune`}".gsub(/\n/, ' ').gsub(/\t/, ' ')
      end

      bot.plugin("language") do |m|
        m.answer "I am written in Ruby using Cinch. Check it out on github -> http://github.com/injekt/cinch"
      end

      bot.plugin("you suck", :prefix => :bot) do |m|
        m.answer "I will go to the animal shelter and find the saddest, cutest kitten there. I will buy you this kitten. You will fall in love with this kitten. And then, in the middle of the night, I will sneak into your house and I will punch you in the face."
      end

      bot.plugin("pull my finger", :prefix => :bot) do |m|
        m.answer "get away from me. you. sick. fuck."
      end

      bot.plugin "lastlog" do |m|
        m.reply db.last_log_message
      end

      started = Time.now
      bot.plugin 'stats' do |m|
        m.reply "Up since #{started}"
        m.reply "#{db.definition_count} total definitions"
        m.reply "#{db.log_count} total log entries"
      end
      
      bot.plugin 'joke' do |m|
        m.reply 'Ba-DUM Tish!'
      end
    end    
  end
end
