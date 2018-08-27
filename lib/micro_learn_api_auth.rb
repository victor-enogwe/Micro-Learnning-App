require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/param'
require 'jwt'
require 'rack'

# micro learning class
class MicroLearnApiAuth < Sinatra::Base
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
    content_type :json
    request.body.rewind
    params[:id] = params[:id].to_i if params[:id]
    params[:category_id] = params[:category_id].to_i if params[:category_id]
  end

  use ErrorHandler
  use JwtAuth

  helpers Sinatra::Param
  helpers Sinatra::PermissionHelper
  helpers Sinatra::AuthHelper
  helpers Sinatra::CategoryHelper
  helpers Sinatra::UserHelper
  helpers Sinatra::CourseHelper

  register Sinatra::ActiveRecordExtension
  register Sinatra::ApiAuthRoutes
end
