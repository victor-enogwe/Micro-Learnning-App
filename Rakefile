if ENV['RACK_ENV'] == 'development' || !ENV['RACK_ENV']
  require 'dotenv'
  Dotenv.overload
end

require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

# get the path of the root of the app
APP_ROOT = File.expand_path(__dir__)

# require the model(s)
Dir.glob(File
  .join(APP_ROOT, 'db', 'models', '*.rb')).each { |file| require file }
