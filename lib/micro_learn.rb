require 'sinatra/base'
require "sinatra/reloader" if development?
require 'rack'
require 'slim'

# micro learning class
class MicroLearn < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  # GZip compession
  use Rack::Deflater

  register Sinatra::PublicRoutes

  Slim::Engine.options[:disable_escape] = true
end
