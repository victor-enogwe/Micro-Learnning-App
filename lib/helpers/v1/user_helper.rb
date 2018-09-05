# Sinatra DSL
module Sinatra
  # user Helper class
  module UserHelper
    def validate_create_user_params(required = true)
      password = 'password must be alphanumeric 7-20 characters'
      name = 'name must be 2-20 alphabets long'
      param :fname, String, required: required, format: /[A-Za-z]{2,20}/, message: name
      param :lname, String, required: required, format: /[A-Za-z]{2,20}/, message: name
      param :email, String, required: required, format: URI::MailTo::EMAIL_REGEXP
      param :password, String, required: required, format: /[A-Za-z0-9]{7,20}/, message: password
    end

    def validate_add_course_params(required = true)
      param :course_id, Integer, min: 1, required: required
      param :user_id, Integer, min: 1, required: required
      param :registration_date, Date, required: required
      param :learning_interval_days, Integer, min: 1, max: 10, required: required
      param :daily_delivery_time, min: 1, max: 10, required: required
    end

    def validate_find_user_courses_params
      param :limit, Integer, min: 1, max: 1000, default: 100
      param :offset, Integer, min: 0, max: 1000, default: 0
      param :user_id, Integer, min: 1
    end

    def validate_instructor_requests_params
      param :limit, Integer, min: 1, max: 1000, default: 100
      param :offset, Integer, min: 0, max: 1000, default: 0
    end

    def create_user(user)
      user = User.create! user
      user_role = Role.find_by_name 'user'
      user.permissions << user_role.permissions.all
      [201, { status: 'success', data: { user: user } }.to_json]
    end

    def find_user_by_email(email)
      User.find_by email: email
    end

    def format_find_user_courses(courses)
      courses.map do |course|
        user = course.course.user
        user_course = course.course
        {
          id: user_course[:id],
          title: user_course[:title],
          description: user_course[:description],
          creator: { name: "#{user[:fname]} #{user[:lname]}", id: user[:id] },
          category: course.course.category
        }
      end
    end

    # route methods
    def register_user
      validate_create_user_params
      user = create_user ::JSON.parse request.body.read
      [200, { status: 'success', data: { user: user } }.to_json]
    end

    def update_user
      param :user_id, Integer, min: 1, required: true
      validate_create_user_params false
      permission params[:user_id].to_i, ['update_profile'], ['manage_users']
      user = User.update params[:user_id], JSON.parse(request.body.read)
      { status: 'success', data: { user: user } }.to_json
    end

    def find_user
      param :user_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, ['update_profile'], ['manage_users']
      user = User.select(User.attribute_names - ['password_digest']).find params[:user_id]
      [200, { status: 'success', data: { user: user } }.to_json]
    end

    def delete_user
      param :user_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, ['delete_profile'], ['manage_users']
      User.delete params[:user_id]
      message = "user with #{params[:user_id]} deleted"
      [200, { status: 'success', message: message }.to_json]
    end

    def add_permissions
      param :permission, String, format: /\w+/, required: true
      permission nil, [], ['manage_users']
      access = find_permission_by_name params[:permission]
      user = User.find params[:id]
      user.permissions << access
      [200, { status: 'success', data: { user: user } }.to_json]
    end

    def become_instructor
      param :user_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, ['update_profile'], ['manage_users']
      exists = InstructorRequest.exists? user_id: params[:user_id]
      raise 'you have already made this request' if exists
      request = InstructorRequest.create user_id: params[:user_id]
      [200, { status: 'success', data: { request: request } }.to_json]
    end

    def approve_instructor
      param :request_id, Integer, min: 1, required: true
      param :user_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, [], ['manage_users']
      auth = %w[
        create_course
        update_course
        delete_course
        create_topic
        update_topic
        delete_topic
      ]
      user = User.find params[:user_id]
      permissions = Permission.where(name: auth)
      InstructorRequest.update params[:request_id], approved: true
      user.permissions << permissions
      [200, { status: 'success', message: 'user now an instructor' }.to_json]
    end

    def delete_instructor_request
      param :request_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, [], ['manage_users']
      request = InstructorRequest.find params[:request_id]
      request.delete
      [200, { status: 'success', message: 'request deleted' }.to_json]
    end

    def instructor_requests
      validate_instructor_requests_params
      permission nil, [], ['manage_users']
      requests = InstructorRequest.includes(:user).where(approved: false)
      count = requests.count
      requests = requests.limit(params[:limit]).offset(params[:offset])
      status = { status: 'success', data: { requests: requests, count: count } }
      [200, status.to_json(include: %i[user])]
    end

    def instructor_request
      param :user_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, ['update_profile'], ['manage_users']
      request = InstructorRequest.find_by user_id: params[:user_id]
      [200, { status: 'success', data: { request: request } }.to_json]
    end

    def add_user_course
      validate_add_course_params
      permission params[:user_id].to_i, ['update_profile'], ['manage_users_courses']
      user_course = UserCourse.exists? user_id: params[:user_id], course_id: params[:course_id]
      raise 'already enroled in this course' if user_course
      user = User.find params[:user_id]
      user_course = user.user_courses.create JSON.parse(request.body.read)
      [201, { status: 'success', data: { user_course: user_course } }.to_json]
    end

    def find_user_courses
      validate_find_user_courses_params
      permission params[:user_id].to_i, ['update_profile'], ['manage_users_courses']
      courses = UserCourse.includes(course: %i[user category]).where user_id: params[:user_id]
      count = courses.count
      courses = courses.limit(params[:limit]).offset(params[:offset])
      courses = format_find_user_courses courses
      status = { status: 'success', data: { courses: courses, count: count } }
      [200, status.to_json]
    end

    def find_user_course
      param :user_id, Integer, min: 1, required: true
      param :course_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, ['update_profile'], ['manage_users_courses']
      user_courses = UserCourse.where(
        user_id: params[:user_id], course_id: params[:course_id]
      )
      [200, { status: 'success', data: { user_courses: user_courses } }.to_json]
    end

    def update_user_course
      param :user_id, Integer, min: 1, required: true
      param :course_id, Integer, min: 1, required: true
      param :user_course_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, ['update_profile'], ['manage_users_courses']
      user_course = UserCourse.find_by(
        id: params[:user_course_id], user_id: params[:user_id], course_id: params[:course_id]
      )
      user_course.update JSON.parse(request.body.read)
      user_course = UserCourse.find params[:user_course_id]
      [200, { status: 'success', data: { user_course: user_course } }.to_json]
    end

    def delete_user_course
      param :user_id, Integer, min: 1, required: true
      param :course_id, Integer, min: 1, required: true
      param :user_course_id, Integer, min: 1, required: true
      permission params[:user_id].to_i, ['update_profile'], ['manage_users_courses']
      user_course = UserCourse.find_by(
        id: params[:user_course_id], user_id: params[:user_id], course_id: params[:course_id]
      )
      user_course.delete
      message = "user course with #{user_course.id} deleted"
      [200, { status: 'success', message: message }.to_json]
    end
  end

  helpers UserHelper
end
