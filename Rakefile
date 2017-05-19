require 'rake'
# require 'hanami/rake_tasks'
require 'rom'
require 'rom-sql'
require 'pg'
require 'rom/sql/rake_task'
require 'rake/testtask'
require 'dotenv'
HANAMI_ENV = ENV.fetch('HANAMI_ENV', 'development')
Dotenv.load(".env.#{HANAMI_ENV}")

namespace :db do
  task :setup do
    ROM.container(:sql, ENV['DATABASE_URL'], extensions: [:pg_json])
  end
end

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs    << 'spec'
  t.warning = false
end

task default: :test
task spec: :test
