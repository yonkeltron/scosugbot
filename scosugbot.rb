#!/usr/bin/env ruby

puts "Engaging warp drive at #{Time.now.utc}"

require 'rubygems'
require 'bundler'
Bundler.setup
require 'cinch'
require_relative './libscosugbot'
require 'yaml'

print "Loading configuration data..."
config = YAML.load_file('config.yml')
puts "Done."

print "Initializing database connection..."
DATABASE = LibScosugBot::Storage::MongoStore.new(config['mongodb']['db'])
puts "Done. Connected -> #{DATABASE}"

print "Defining plugins..."
bot = LibScosugBot::Bot.setup(config['server'], config['nick'], [config['channels']], DATABASE)
puts "Done."

puts "Starting up!"
bot.start
