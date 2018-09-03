#  Sinatra DSL
module Sinatra
  # Api Auth Route(s)
  module ApiAuthRoutes
    def self.registered(app)
      course_routes app
      course_topics_routes app
      user_routes app
      user_permissions_routes app
      user_courses_routes app
      user_course_topics_routes app
      category_routes app
    end

    def self.course_routes(app)
      app.post('/courses') { create_course }
      app.put('/courses/:course_id') { update_course }
      app.delete('/courses/:course_id') { delete_course }
    end

    def self.course_topics_routes(app)
      app.post('/courses/:course_id/topics') { create_course_topic }
      app.put('/courses/:course_id/topics/:topic_id') { update_course_topic }
      app.delete('/courses/:course_id/topics/:topic_id') { delete_course_topic }
    end

    def self.user_routes(app)
      app.get('/users') { find_users }
      app.get('/users/:user_id') { find_user }
      app.put('/users/:user_id') { edit_user }
      app.delete('/users/:user_id') { delete_user }
    end

    def self.user_permissions_routes(app)
      app.get('/instructor-requests') { instructor_requests }
      app.delete('/instructor-requests/:request_id') { delete_instructor_request }
      app.patch('/instructor-requests/:request_id') { approve_instructor }
      app.get('/users/:user_id/instructor') { instructor_request }
      app.post('/users/:user_id/instructor') { become_instructor }
      app.post('/users/:user_id/permissions') { add_user_permissions }
      app.delete('/users/:user_id/permissions') { delete_user_permissions }
    end

    def self.user_courses_routes(app)
      app.get('/users/:user_id/courses') { find_user_courses }
      app.get('/users/:user_id/courses/:course_id/usercourses') { find_user_course }
      app.post('/users/:user_id/courses/:course_id/usercourses') { add_user_course }
      app.put('/users/:user_id/courses/:course_id/usercourses/:user_course_id') { update_user_course }
      app.delete('/users/:user_id/courses/:course_id/usercourses/:user_course_id') { delete_user_course }
    end

    def self.user_course_topics_routes(app)
      app.get('/users/:user_id/courses/:course_id/topics/:topic_id') { find_user_course_topic }
    end

    def self.category_routes(app)
      app.post('/categories') { create_category }
      app.put('/categories/:category_id') { update_category }
      app.delete('/categories/:category_id') { delete_category }
    end
  end

  register ApiAuthRoutes
end
