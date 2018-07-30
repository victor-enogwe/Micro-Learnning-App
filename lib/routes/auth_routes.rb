require_relative '../controllers/auth_controller'

#  Sinatra DSL
module Sinatra
  # Login Route(s)
  module AuthRoutes
    def self.registered(app)
      app.post '/api/v1/login' do
        request.body.rewind
        content_type :json
        payload = JSON.parse request.body.read
        email = payload[:email]
        password = payload[:password]
        AuthController.issue_token email, password
      end
    end
  end

  register AuthRoutes
end
