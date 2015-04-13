APP_FILE  = 'app.rb'
APP_CLASS = 'JasperOnSinatra'

require "fileutils"
require 'sinatra/assetpack/rake'
require "sinatra/asset_pipeline/task.rb"
require "pry-byebug"

require_relative "routes/base"
require_relative "config/initializers/sequel"

namespace :db do
  Sequel.extension(:migration)
  migrations_dir = "db/migrations"

  desc 'run pending migrations - e.g., rake "db:migrate[201306261051]"'
  task :migrate, :migration do |t, args|
    target_migration = args[:migration] ? args[:migration].to_i : nil
    Sequel::Migrator.apply(DB, migrations_dir, target_migration)
  end

  desc "rollback all database migrations"
  task :reset do
    Sequel::Migrator.apply(DB, migrations_dir, 0)
    Sequel::Migrator.apply(DB, migrations_dir)
  end

  task :seed do
    seed_file = File.join(File.dirname(__FILE__), "db", "seeds.rb")
    load(seed_file) if File.exist?(seed_file)
  end
end

namespace :g do
  task :migration, :fname do |t, args|
    args.with_defaults(fname: "new_migration")
    Dir.chdir("db/migrations") do
      timestamp = Time.now.strftime("%Y%m%d%H%M")
      filename = "#{timestamp}_#{args[:fname]}.rb"
      File.open(filename, "w") do |f|
        f << <<-SCAFFOLD
Sequel.migration do
  up do
  end

  down do
  end
end
SCAFFOLD
      end
    end
  end
end

