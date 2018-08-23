require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
require "sinatra/reloader" if development?
require 'sinatra/param'
require 'jwt'
require 'rack'

# micro learning class
class MicroLearnApi < Sinatra::Base
  configure :development, :test do
    Dotenv.overload
  end

  configure :development do
    register Sinatra::Reloader
  end

  set :database_url, ENV['DATABASE_URL']
  set :dump_errors, false
  set :raise_errors, true
  set :show_exceptions, false

  use Rack::Parser, content_types: {
    'application/json' => proc { |body| ::MultiJson.decode body }
  }

  before do
    request.path_info.chomp!('/')
    content_type :json
    request.body.rewind
  end

  use ErrorHandler
  use JwtAuth

  helpers Sinatra::Param
  helpers Sinatra::PermissionHelper
  helpers Sinatra::AuthHelper
  helpers Sinatra::UserHelper
  helpers Sinatra::CourseHelper

  register Sinatra::ActiveRecordExtension
  register Sinatra::AuthRoutes
  register Sinatra::UserRoutes
  register Sinatra::CourseRoutes
end
