module LibScosugBot
  class MemorizationPlugin
    include Cinch::Plugin
    include LibScosugBot::Views

    prefix '!'

    match /memorize (.+) is (.+)$/, :method => :memorize
    match /recall (.+)$/, :method => :recall
    match /^,(.+)$/, :method => :recall, :use_prefix => false
    match /tell (\S+) about (.+)$/, :method => :tell
    match /forget (.+)$/, :method => :forget

    def memorize(m, thing, definition)
      m.reply MemorizationSnippets.memorize_snippet(thing,
                                                    DATABASE.memorize(thing.downcase, definition))
    end

    def recall(m, thing)
      m.reply MemorizationSnippets.recall_snippet(thing, DATABASE.recall(thing.downcase))
    end

    def tell(m, who, thing)
      definition = MemorizationSnippets.recall_snippet(thing, DATABASE.recall(thing))
      m.reply "#{who}: #{definition}"
    end

    def forget(m, thing)
      if DATABASE.forget(thing.downcase)
          rep = "Forgot #{thing}"
      else
        rep = "Could not forget #{thing}. Was it ever defined?"
      end
      m.reply rep
    end
  end
end
