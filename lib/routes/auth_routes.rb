require 'sinatra/base'

#  Sinatra DSL
module Sinatra
  # Login Route(s)
  module AuthRoutes
    def self.registered(app)
      app.put('/user/create') { register_user }
      app.post('/login') { login }
    end
  end

  register AuthRoutes
end
