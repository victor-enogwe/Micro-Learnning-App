#  Sinatra DSL
module Sinatra
  # Public Routes
  module PublicRoutes
    def self.registered(app)
      # app.before { content_type :html }

      app.get '/' do
        slim :home
      end

      app.get '/login' do
        @title = 'Login'
        slim :login
      end

      app.get '/register' do
        @title = 'Register'
        slim :register
      end

      app.get '/courses' do
        @title = 'Courses'
        slim :courses
      end

      app.get '/courses/new' do
        @title = 'Edit Course'
        slim :edit_course
      end

      app.get '/courses/:id/edit' do
        @title = 'Courses'
        slim :edit_course
      end

      app.not_found do
        @title = '404'
        slim :not_found
      end
    end
  end

  register PublicRoutes
end
