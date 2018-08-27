# error handler class
class ErrorHandler
  def initialize(app)
    @app = app
    @content_type = { 'Content-Type' => 'application/json' }
    @errors = {
      'JWT::DecodeError': { code: 401, message: 'invalid token!' },
      'JWT::ExpiredSignature': { code: 401, message: 'expired token!' },
      'JWT::InvalidIssuerError': { code: 401, message: 'invalid token issuer' },
      'JWT::InvalidIatError': { code: 401, message: 'invalid token IAT' },
      'ActiveModel::UnknownAttributeError': { code: 422 },
      'ActiveRecord::RecordNotFound': { code: 404 },
      'ActiveRecord::RecordInvalid': { code: 409 },
      'SecurityError': { code: 401 },
      'default': { code: 500 }
    }
  end

  def call(env)
    @app.call env
  rescue StandardError => error
    # env['rack.errors'].puts error
    # env['rack.errors'].puts error.backtrace.join("\n")
    # env['rack.errors'].flush
    error_json error
  end

  def error_json(error)
    error_data = @errors[:"#{error.class}"] || @errors[:default]
    code = error_data[:code] || 500
    message = error_data[:message] || error.to_s
    hash = { status: 'error', message: message }
    hash[:backtrace] = error.backtrace if ENV['RACK_ENV'] == 'development'
    [code, @content_type, [hash.to_json]]
  end
end
