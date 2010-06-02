Factory.define :log_entry, :class => LibScosugBot::Storage::LogEntry do |le|
  le.message "Log Message"
  le.service "PANDA"
  le.priority 42
end
