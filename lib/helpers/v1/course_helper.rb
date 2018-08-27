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
      param :course_id, Integer, min: 1, formmat: /\d+/, required: true
      param :title, String, required: required, min_length: 5, max_length: 100, message: title_message
      param :description, String, required: required, min_length: 50, max_length: 1000, message: description_message
      param :url, String, format: URI.regexp(%w[http https]), required: required, message: url_message
    end

    # route handlers
    def create_course
      validate_create_course_params
      course = JSON.parse request.body.read
      user = request.env.values_at :user
      course['creator_id'] = user[0]['id']
      permission nil, ['create_course']
      course = Course.create course
      { status: 'success', data: { course: course } }.to_json
    end

    def create_course_topic
      validate_create_course_topic_params
      new_topic = JSON.parse request.body.read
      course = Course.find params[:course_id]
      permission course[:creator_id], ['create_topic']
      topic = course.topics.create new_topic
      { status: 'success', data: { topic: topic } }.to_json
    end

    def update_course
      param :course_id, Integer, min: 1, formmat: /\d+/, required: true
      validate_create_course_params false
      permission params[:course_id], ['update_course']
      course = Course.update params[:course_id], JSON.parse(request.body.read)
      { status: 'success', data: { course: course } }.to_json
    end

    # def update_course_topic
    #   param :course_id, Integer, min: 1, formmat: /\d+/, required: true
    #   validate_create_course_params false
    #   permission params[:course_id], ['update_course']
    #   course = Course.update params[:course_id], JSON.parse(request.body.read)
    #   { status: 'success', data: { course: course } }.to_json
    # end

    def find_course
      param :course_id, Integer, min: 1, required: true
      course = Course.includes(:topics).find params[:course_id]
      [200, { status: 'success', data: { course: course } }.to_json]
    end

    def delete_course
      param :course_id, Integer, min: 1, formmat: /\d+/, required: true
      permission params[:course_id], ['delete_course']
      Course.delete params[:course_id]
    end
  end

  helpers CourseHelper
end
