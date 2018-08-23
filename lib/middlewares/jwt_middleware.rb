# Jwt Middleware
class JwtAuth
  def initialize(app)
    @app = app
    @authed_routes = [
      '/users/'
    ]
  end

  def auth_credentials(env)
    options = { algorithm: ENV['JWT_ALGO'], iss: ENV['JWT_ISSUER'] }
    token = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
    payload = JWT.decode token, ENV['JWT_SECRET'], true, options
    env[:scopes] = payload[0]['scopes']
    env[:user] = payload[0]['user']
  end

  def call(env)
    current_route = env['PATH_INFO']
    auth = !@authed_routes.all? { |route| !(/#{route}\w+/.match current_route) }
    auth_credentials env if auth
    @app.call env
  end
end
