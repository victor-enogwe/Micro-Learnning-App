require 'dotenv' if ENV['RACK_ENV'] == 'development'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/param'
require 'jwt'
require 'rack'

# micro learning class
class MicroLearnApi < Sinatra::Base
  configure :development, :test do
    Dotenv.overload
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
    request.body.rewind
    content_type :json
    user_token request.env
    params[:id] = params[:id].to_i if params[:id]
    params[:category_id] = params[:category_id].to_i if params[:category_id]
  end

  def user_token(env)
    options = { algorithm: ENV['JWT_ALGO'], iss: ENV['JWT_ISSUER'] }
    token = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
    payload = JWT.decode token, ENV['JWT_SECRET'], true, options
    env[:scopes] = payload[0]['scopes']
    env[:user] = payload[0]['user']
  rescue StandardError
    true
  end

  use ErrorHandler

  helpers Sinatra::Param
  helpers Sinatra::PermissionHelper
  helpers Sinatra::AuthHelper
  helpers Sinatra::CategoryHelper
  helpers Sinatra::UserHelper
  helpers Sinatra::CourseHelper

  register Sinatra::ActiveRecordExtension
  register Sinatra::ApiRoutes
end
