require 'sinatra/base'
require 'jwt'

#  auth module
module Sinatra
  # auth helper
  module AuthController
    def payload(user)
      {
        exp: Time.now.to_i + 60 * 60,
        iat: Time.now.to_i,
        iss: ENV['JWT_ISSUER'],
        scopes: user[:permissions].map { |permission| permission[:name] },
        user: { id: user[:id] }
      }
    end

    def create_token(payload)
      JWT.encode(payload, ENV['JWT_SECRET'], ENV['JWT_ALGO'])
    end

    def decode_token(token)
      options = { algorithm: ENV['JWT_ALGO'], iss: ENV['JWT_ISSUER'] }
      JWT.decode token, ENV['JWT_SECRET'], true, options
    end

    def validate_login_params
      param :password, String, required: true, message: 'password required'
      param :email, String, required: true, format: URI::MailTo::EMAIL_REGEXP
    end

    def login
      validate_login_params
      user = find_user_by_email params[:email]
      if user && user.password.is_password?(params[:password])
        token = create_token payload user
        { status: 'success', data: { token: token } }.to_json
      else
        halt 401, { status: 'error', error: 'invalid login' }.to_json
      end
    end
  end

  helpers AuthController
end
