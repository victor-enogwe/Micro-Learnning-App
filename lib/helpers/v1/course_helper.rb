# Sinatra DSL
module Sinatra
  # course Helper
  module CourseHelper
    def validate_create_course_params(required = true)
      category_id_message = 'category id must be a positive integer'
      title_message = 'Title must be 5-100 characters and alphanumeric.'
      description_message = 'Description must be 50-1000 characters long.'
      param :title, String, required: required, min_length: 5, max_length: 100, message: title_message
      param :description, String, required: required, min_length: 50, max_length: 1000, message: description_message
      param :category_id, Integer, min: 1, required: required, message: category_id_message
    end

    def validate_create_course_topic_params(required = true)
      url_message = 'please supply a valid url'
      title_message = 'Title must be 5-100 characters and alphanumeric.'
      description_message = 'Description must be 50-1000 characters long.'
      param :course_id, Integer, min: 1, required: true
      param :title, String, required: required, min_length: 5, max_length: 100, message: title_message
      param :description, String, required: required, min_length: 50, max_length: 1000, message: description_message
      param :url, String, format: URI.regexp(%w[http https]), required: required, message: url_message
    end

    def validate_update_course_topic_params
      param :course_id, Integer, min: 1, required: true
      param :topic_id, Integer, min: 1, required: true
      validate_create_course_topic_params false
    end

    def validate_find_courses_params
      param :limit, Integer, min: 1, max: 1000, default: 100
      param :offset, Integer, min: 0, max: 1000, default: 0
      param :category_id, Integer, min: 1
      param :creator_id, Integer, min: 1
    end

    # route handlers
    def create_course
      validate_create_course_params
      course = JSON.parse request.body.read
      user = request.env.values_at :user
      course['creator_id'] = user[0]['id']
      permission nil, ['create_course'], ['manage_courses']
      course = Course.create course
      [201, { status: 'success', data: { course: course } }.to_json]
    end

    def create_course_topic
      validate_create_course_topic_params
      new_topic = JSON.parse request.body.read
      course = Course.find params[:course_id]
      permission course[:creator_id].to_i, ['create_topic'], ['manage_topics']
      topic = course.topics.create new_topic
      [201, { status: 'success', data: { topic: topic } }.to_json]
    end

    def update_course
      param :course_id, Integer, min: 1, required: true
      validate_create_course_params false
      course = Course.find params[:course_id]
      permission course[:creator_id].to_i, ['update_course'], ['manage_courses']
      course = course.update JSON.parse(request.body.read)
      [200, { status: 'success', data: { course: course } }.to_json]
    end

    def update_course_topic
      validate_update_course_topic_params
      course = Course.find params[:course_id]
      permission course[:creator_id].to_i, ['update_topic'], ['manage_topics']
      topic_update = JSON.parse(request.body.read)
      topic = course.topics.update params[:topic_id], topic_update
      [200, { status: 'success', data: { topic: topic } }.to_json]
    end

    def find_course
      param :course_id, Integer, min: 1, required: true
      course = Course.includes(:topics, :user, :category, :users).find params[:course_id]
      status = { status: 'success', data: { course: course } }
      [200, status.to_json(include: %i[topics category user])]
    end

    def find_courses
      validate_find_courses_params
      category_id = params[:category_id]
      creator_id = params[:creator_id]
      courses = Course.includes(:user, :category)
      courses = courses.where(category_id: category_id) if category_id
      courses = courses.where(creator_id: creator_id) if creator_id
      count = courses.count
      courses = courses.limit(params[:limit]).offset(params[:offset])
      status = { status: 'success', data: { courses: courses, count: count } }
      [200, status.to_json(include: %i[user category])]
    end

    def delete_course
      param :course_id, Integer, min: 1, required: true
      course = Course.find params[:course_id]
      permission course[:creator_id].to_i, ['delete_course'], ['manage_courses']
      Course.delete params[:course_id]
      message = "course with #{params[:course_id]} deleted"
      [200, { status: 'success', message: message }.to_json]
    end

    def delete_course_topic
      param :course_id, Integer, min: 1, required: true
      param :topic_id, Integer, min: 1, required: true
      course = Course.includes(:topics).find params[:course_id]
      permission course[:creator_id].to_i, ['delete_topic'], ['manage_topics']
      course.topics.delete params[:topic_id]
      message = "topic with #{params[:topic_id]} deleted"
      [200, { status: 'success', message: message }.to_json]
    end

    def find_course_topic
      # param :course_id, Integer, min: 1, required: true
      # param :topic_id, Integer, min: 1, required: true
      # scopes, user = request.env.values_at :scopes, :user
      # topic = UserTopic.exists? user_id: user['id'], course_id: params[:course_id]
    end
  end

  helpers CourseHelper
end
