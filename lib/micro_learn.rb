require 'sinatra/base'

##
# micro learning class
class MicroLearn < Sinatra::Base
  configure :development do
    Sinatra::Application.reset!
    use Rack::Reloader
  end

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
