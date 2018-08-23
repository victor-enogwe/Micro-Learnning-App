# Sinatra DSL
module Sinatra
  # course Helper
  module CourseHelper
    def validate_create_course_params(required = true)
      param :title, String, required: required, format: /[A-Za-z]{2,20}/
      param :description, String, required: required, format: /[A-Za-z]{2,20}/
    end

    # route handlers
    def create_course
      validate_create_course_params
      course = JSON.parse request.body.read
      user = request.env.values_at :user
      course[:creator_id] = user['id']
      permission nil, ['create_course']
      course = Course.create course
      { status: 'success', data: { course: course } }.to_json
    end
  end

  helpers CourseHelper
end
