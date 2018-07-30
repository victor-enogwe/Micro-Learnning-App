require 'jwt'
require_relative './user_controller'

#  auth module
module AuthController
  def payload(user)
    {
      exp: Time.now.to_i + 60 * 60,
      iat: Time.now.to_i,
      iss: ENV['JWT_ISSUER'],
      # scopes: ['add_money', 'remove_money', 'view_money'],
      user: user[:id] ? { id: user[:id] } : nil
    }
  end

  def self.create_token(payload)
    id = payload[:user][:id]
    id ? JWT.encode(payload, ENV['JWT_SECRET'], ENV['JWT_ALGO']) : nil
  end

  def decode_token(token)
    options = { algorithm: ENV['JWT_ALGO'], iss: ENV['JWT_ISSUER'] }
    JWT.decode token, ENV['JWT_SECRET'], true, options
  end

  def self.current_user(user)
    user.password == user.supplied_password ? user : nil
  end

  def self.issue_token(email, password)
    create_token payload current_user UserController.find_user email, password
  end
end
