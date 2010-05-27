# SCOSUGBOT

The official IRC bot of the Southern Connecticut Open Source User
Group! 

# About 

It's written in Ruby using the [Cinch](http://github.com/injekt/cinch)
framework. You can interact with scosugbot on the #scosug channel on
Freenode.

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
`!fortune` #=> <whatever>

# Requirements

In order to function, scosugbot has a few required
dependencies:

* Cinch framework
* MongoDB
* Mongoid
* JSON (the gem)
* Rake
* RSpec (for tests)
* Fortune (install from package manager)

You can install MongoDB using your system's package manager or by
following the [instructions on the MongoDB
site](http://www.mongodb.org/display/DOCS/Quickstart). As for the rest,
you can install the required gems with this command (assumes you have
rubygems):

`gem install cinch mongoid bson_ext json rake rspec`

# Language
Right now, scosug has some foul language in its vocabulary. Enjoy.

# ToDos
* Actually implement stable MongoDB support