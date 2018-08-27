#  Sinatra DSL
module Sinatra
  # Public Routes
  module PublicRoutes
    def self.registered(app)
      # app.before { content_type :html }

      app.get '*' do
        @title = 'home'
        @app_root = File.expand_path('../public/js', File.dirname(__FILE__))
        @scripts = Dir.glob(File.join(@app_root, '*.js'))
        @scripts.map! { |script| File.basename(script, '.js') }.sort!
        slim :home
      end
    end
  end

  register PublicRoutes
end
