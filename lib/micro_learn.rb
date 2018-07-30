require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'rack'
require 'slim'

# micro learning class
class MicroLearn < Sinatra::Base
  configure :development, :test do
    Dotenv.overload
  end

  configure :development do
    Sinatra::Application.reset!
    use Rack::Reloader
  end

  register Sinatra::ActiveRecordExtension
  # register Sinatra::PublicRoutes
  register Sinatra::AuthRoutes

  set :database_url, ENV['DATABASE_URL']
  set :public_folder, 'assets'

  Slim::Engine.options[:disable_escape] = true
end
