require "active_record"
require "with_model"

RSpec.configure do |config|
  config.extend WithModel
end

jruby = RUBY_PLATFORM =~ /\bjava\b/
adapter = jruby ? "jdbcsqlite3" : "sqlite3"

# Importeroo requires ActiveRecord::Base.connection to be established.
# If ActiveRecord already has a connection, as in a Rails app, this is unnecessary.
ActiveRecord::Base.establish_connection(:adapter => adapter, :database => ":memory:")
