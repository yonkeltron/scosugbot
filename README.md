# SCOSUGBOT

The official IRC bot of the Southern Connecticut Open Source User
Group!

# About

It's written in Ruby using the [Cinch](http://github.com/injekt/cinch)
framework while relying on the super-cool MongoDB as a backend. You
can interact with scosugbot on the #scosug channel on Freenode.

# Features

Current features:

## Memorization

`!memorize scosug is wonderful!`

`!recall scosug` #=> "I recall that scosug is wonderful!"

`,scosug` #=> "I recall that scosug is wonderful!"

`!tell yonkeltron about scosug` #=> "yonkeltron: I recall that scosug is wonderful!"

## Ping
`!ping` #=> "pong -> [timestamp]"

## Fortune
`!fortune` #=> "WHA!"

# Requirements

In order to function, scosugbot has a few required
dependencies:

* Ruby 1.9.2
* [bundler](http://github.com/carlhuda/bundler)
* Cinch framework
* MongoDB (the database, install from package manager)
* [Mongoid](http://mongoid.org/) (the gem)
* JSON (the gem)
* Rake
* Fortune (install from package manager)

For testing:

* RSpec
* Factory Girl](http://github.com/thoughtbot/factory_girl)

Install MongoDB using your system's package manager or by following
the [instructions on the MongoDB
site](http://www.mongodb.org/display/DOCS/Quickstart). As for the
rest, you can use carlhuda's most excellent
[bundler](http://github.com/carlhuda/bundler) tool to install the gems
for you. No worries, just run a `bundle install` in the source
directory and the appropriate data will be read from the Gemfile
without issue.

# Run the tests

Once you have installed the requirements, you can run the tests with
little more than a `bundle exec rake`. Make sure MongoDB is running as
the test suite also serves as a way to veryify connectivity and
environmental configuration.

The tests are not so speedy because they actually have to do some
database hitting but I hope to make them faster in the
future. Improvements welcome.

# Language
Right now, scosug has some foul language in its vocabulary. Enjoy.

# ToDos
* Weather plugin
* Port to CouchDB