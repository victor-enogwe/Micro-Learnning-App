require 'sinatra/base'
require 'rack'
require 'slim'

# micro learning class
class MicroLearn < Sinatra::Base
  # GZip compession
  use Rack::Deflater

  register Sinatra::PublicRoutes

  Slim::Engine.options[:disable_escape] = true
end
