require 'rubygems'
require 'bundler'
require 'rack/parser'
# require 'rack/protection'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

# get the path of the root of the app
APP_ROOT = File.expand_path(__dir__)

# require the model(s)
Dir.glob(File
  .join(APP_ROOT, 'db', 'models', '*.rb')).each { |file| require file }

# require middleware(s)
Dir.glob(File
  .join(APP_ROOT, 'lib', 'middlewares', '*.rb')).each { |file| require file }

# require controller(s)
Dir.glob(File
  .join(APP_ROOT, 'lib', 'controllers', '*.rb')).each { |file| require file }


# require route(s)
Dir.glob(File
    .join(APP_ROOT, 'lib', 'routes', '*.rb')).each { |file| require file }

require './lib/micro_learn_api'
require './lib/micro_learn'

# use Rack::Protection

run Rack::URLMap.new '/' => MicroLearn, '/api/v1' => MicroLearnApi
