# Sinatra DSL'
module Sinatra
  # Course Routes
  module CourseRoutes
    def self.registered(app)
      app.post('/courses') { create_course }
    end
  end
end
