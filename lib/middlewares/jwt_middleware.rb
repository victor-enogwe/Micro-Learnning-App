# Jwt Middleware
class JwtAuth
  def initialize(app)
    @app = app
  end

  def auth_credentials(env)
    options = { algorithm: ENV['JWT_ALGO'], iss: ENV['JWT_ISSUER'] }
    token = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
    payload = JWT.decode token, ENV['JWT_SECRET'], true, options
    env[:scopes] = payload[0]['scopes']
    env[:user] = payload[0]['user']
  end

  def call(env)
    auth_credentials env
    @app.call env
  end
end
