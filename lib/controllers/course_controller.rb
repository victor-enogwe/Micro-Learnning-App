require 'sinatra/base'

#  helper
module Sinatra
  # course helper
  module CourseController
    def find_course_by_id(id)
      Course.find_by_id id
    end

    def find_courses(filter)
      Course.find
    end
  end

  helpers CourseController
end
