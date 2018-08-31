#  Sinatra DSL
module Sinatra
  # Api Route(s)
  module ApiRoutes
    # group routes to reduce method length
    def self.registered(app)
      routes_zero app
      routes_one app
    end

    def self.routes_zero(app)
      app.post('/users') { register_user }
      app.post('/login') { login }
      app.get('/courses') { find_courses }
    end

    def self.routes_one(app)
      app.get('/courses') { find_courses }
      app.get('/courses/:course_id') { find_course }
      app.get('/categories') { find_categories }
      app.get('/categories/:category_id') { find_category }
    end
  end

  register ApiRoutes
end
