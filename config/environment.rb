require 'bundler'

Bundler.require

# custom require
require 'active_support/core_ext/string'
require 'json'
require 'erb'
require 'ostruct'
require 'forwardable'
require 'logger'

$logger = Logger.new(STDOUT)

APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../'))
APP_ENV ||= ENV['RACK_ENV'] || 'development'

# settings
Settings = YAML.load_file("#{APP_ROOT}/config/settings.yml")

# global cache for caching file.read(template) while running sinatra-instance
# comment this line if you don't want to cache templates
#
#$global_template_cache = {} if APP_ENV == 'production'

# init airbrake
#require 'resque/failure/multiple'
#require 'resque/failure/airbrake'
#require 'resque/failure/redis'

#Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
#Resque::Failure.backend = Resque::Failure::Multiple

#Airbrake.configure do |config|
  #config.environment_name = APP_ENV
  #config.ignore << 'Sinatra::NotFound'
  #config.api_key = Settings['airbrake']['key']
  #config.secure = true
#end

# init sql db
#ActiveRecord::Base.establish_connection(Settings["pg"][APP_ENV])

# init no-sql db
$redis = Redis.new(Settings["redis"][APP_ENV])

# requires
Dir.glob("#{APP_ROOT}/{lib,models}/**/*.rb").each(&method(:require))
