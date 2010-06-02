Factory.define :definition, :class => LibScosugBot::Storage::Definition do |d|
  d.sequence(:term) {|n| "term#{n}" }
  d.sequence(:contents) {|n| "content#{n}" }
  d.active true
end
