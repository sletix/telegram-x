APP_ENV = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
#require 'minitest/pride'
#require 'minitest/assert_errors'
#require 'minitest/benchmark'

# require bot env
require File.expand_path(File.join(File.dirname(__FILE__), '../', 'config', 'environment'))

# some stuff here:
Fixtures = YAML.load_file("#{APP_ROOT}/spec/fixtures.yml")
FxU = FxUpdates = Fixtures["updates"]

# colors and format output
reporter_options = { color: true }
reporter_class = if ENV["MiniReporter"] == "default"
  Minitest::Reporters::DefaultReporter
else
  Minitest::Reporters::SpecReporter
end

Minitest::Reporters.use! [ reporter_class.new(reporter_options) ]
