#  Sinatra DSL
module Sinatra
  # Login Route(s)
  module AuthRoutes
    def self.registered(app)
      app.post('/login') { login }
    end
  end

  register AuthRoutes
end
