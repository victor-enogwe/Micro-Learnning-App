# Jwt Middleware
class JwtAuth
  def initialize(app)
    @app = app
  end

  def call env
    options = { algorithm: 'HS256', iss: ENV['JWT_ISSUER'] }
    bearer = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
    payload, header = JWT.decode bearer, ENV['JWT_SECRET'], true, options
    content_type = { 'Content-Type' => 'text/plain' }
    # env[:scopes] = payload['scopes']
    env[:user] = payload['user']
    @app.call env
  rescue JWT::DecodeError
    [401, content_type, ['No token passed.']]
  rescue JWT::ExpiredSignature
    [403, content_type, ['Token expired.']]
  rescue JWT::InvalidIssuerError
    [403, content_type, ['Token invalid issuer.']]
  rescue JWT::InvalidIatError
    [403, content_type, ['Token invalid "issued at" time.']]
  end
end
