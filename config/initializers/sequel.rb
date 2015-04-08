require "sequel"
require "pathname"
require "yaml"
require "logger"
require "uri"

rack_env = ENV["RACK_ENV"] || "development"
db_config = YAML::load(Pathname.new("config/database.yml").open)
env_config = db_config[rack_env]

db_url = env_config["db_url"]

max_connections = ENV["MAX_CONNECTIONS"] || env_config["max_connections"] || 4

DB = Sequel.connect(db_url, max_connections: max_connections.to_i)
DB.loggers << Logger.new($stdout) if ENV["SQL"]

DB.extension :pg_array, :pg_hstore, :pg_json

Sequel.extension :blank, :pg_array_ops, :pg_hstore_ops

Sequel::Model.plugin :validation_helpers

Sequel.default_timezone = :utc