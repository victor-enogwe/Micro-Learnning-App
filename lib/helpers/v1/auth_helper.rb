#  Sinatra DSL
module Sinatra
  # auth Helper
  module AuthHelper
    def login
      validate_login_params
      user = find_user_by_email params[:email]
      if user.try(:authenticate, params[:password])
        token = create_token payload user
        { status: 'success', data: { token: token } }.to_json
      else
        halt 401, { status: 'error', message: 'invalid login' }.to_json
      end
    end

    def payload(user)
      {
        exp: Time.now.to_i + 60 * 60,
        iat: Time.now.to_i,
        iss: ENV['JWT_ISSUER'],
        scopes: user.permissions.map { |scope| scope[:name] },
        user: { id: user[:id], fullname: "#{user[:fname]} #{user[:lname]}", email: user[:email] }
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
      puts params[:password]
      puts params[:email]
      param :password, String, required: true, message: 'password required'
      param :email, String, required: true, format: URI::MailTo::EMAIL_REGEXP
    end
  end

  helpers AuthHelper
end
