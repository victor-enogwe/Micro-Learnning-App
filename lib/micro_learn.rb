require 'sinatra/base'
require 'sinatra/activerecord'

##
# micro learning class
class MicroLearn < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure :development do
    Sinatra::Application.reset!
    use Rack::Reloader
  end

  set :database, ENV['DATABASE_URL']

  def initialize(app)
    super(app)
  end

  set :public_folder, 'assets'

  get '/' do
    'Hello world!'
  end

  get '/:name' do
    "Hello #{params[:name]}"
  end

  not_found do
    erb :not_found
  end
end
