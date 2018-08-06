require 'dotenv'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/param'
require 'rack'

# micro learning class
class MicroLearnApi < Sinatra::Base
  configure :development, :test do
    Dotenv.overload
  end

  configure :development do
    Sinatra::Application.reset!
    use Rack::Reloader
  end

  set :database_url, ENV['DATABASE_URL']

  use Rack::Parser, content_types: {
    'application/json' => proc { |body| ::MultiJson.decode body }
  }

  before do
    content_type :json
    request.body.rewind
  end

  helpers Sinatra::Param
  helpers Sinatra::UserController
  helpers Sinatra::CourseController
  helpers Sinatra::TopicController
  helpers Sinatra::AuthController
  helpers Sinatra::UserCourseController
  helpers Sinatra::UserTopicController

  register Sinatra::ActiveRecordExtension
  register Sinatra::AuthRoutes

  # use JwtAuth
  register Sinatra::UserRoutes
end
