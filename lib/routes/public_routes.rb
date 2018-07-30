require 'slim'

#  Sinatra DSL
module Sinatra
  # Public Routes
  module PublicRoutes
    def self.registered(app)
      app.get '/' do
        slim :home
      end

      app.get '/login' do
        @title = 'Login'
        slim :login
      end

      app.not_found do
        slim :not_found
      end
    end
  end

  register PublicRoutes
end
