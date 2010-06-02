#!/usr/bin/env ruby

puts "Engaging warp drive at #{Time.now.utc}"

require 'rubygems'
require 'bundler'
Bundler.setup
require 'libscosugbot'

print "Initializing database connection..."
db = LibScosugBot::Storage::MongoStore.new('scosugbot')
puts "Done. Connected -> #{db}"

print "Defining plugins..."
bot = LibScosugBot::Bot.setup("irc.freenode.net", "scosugbot", %w{ #scosug }, db)
puts "Done."

puts "Starting up!"
bot.run
