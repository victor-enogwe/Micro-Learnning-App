require 'rubygems'
require 'bundler'
# require 'rack/protection'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

# get the path of the root of the app
APP_ROOT = File.expand_path(__dir__)

# require the model(s)
Dir.glob(File
  .join(APP_ROOT, 'db', 'models', '*.rb')).each { |file| require file }

# require route(s)
Dir.glob(File
    .join(APP_ROOT, 'lib', 'routes', '*.rb')).each { |file| require file }

require './lib/micro_learn'

# GZip compession
use Rack::Deflater
# use Rack::Protection
run MicroLearn
