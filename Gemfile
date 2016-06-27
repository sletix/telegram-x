# frozen_string_literal: true
# A sample Gemfile
source "https://rubygems.org"

gem "httparty"
gem "activesupport", require: false
gem "sinatra"
#gem "sinatra-activerecord"
#gem "pg"
#gem "sidekiq"
gem "rake", require: false
gem "ripl", require: false

gem "redis"

group :production do
  gem "unicorn", require: false
end

group :test do
  gem "minitest", require: false
  gem "minitest-reporters"
  #gem "minitest-assert_errors"
  #gem "database_cleaner"
  #gem "factory_girl", "~> 4.0"
  #
  gem "guard"
  gem "guard-minitest"
end



