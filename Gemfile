source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.0'
# gem 'hanami-model', '~> 1.0'

gem 'pg'

# Added the head version in order to avoid some warnings from the 1.3 version
gem 'rom-repository', :git => 'https://github.com/rom-rb/rom-repository'
gem 'rom-sql', :git => 'https://github.com/rom-rb/rom-sql'

# dry-monads
gem 'dry-monads'

# Kanwei algorithms
gem 'algorithms'

# rack-cache
gem 'rack-cache'
gem 'redis-rack-cache'

# sidekiq
gem 'sidekiq'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun'
  gem 'pry'
  gem 'byebug'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
end

group :test do
  gem 'minitest'
  gem 'minitest-stub_any_instance'
  gem 'capybara'
end

group :production do
  gem 'puma'
end
