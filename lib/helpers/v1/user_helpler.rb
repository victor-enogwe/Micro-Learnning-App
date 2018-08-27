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

    def create_user(user)
      # @TODO exclude password field
      user = User.create! user
      user_role = Role.find_by_name 'user'
      user.permissions << user_role.permissions.all
      user
    end

    def find_user_by_email(email)
      User.find_by email: email
    end

    # route methods
    def register_user
      validate_create_user_params
      user = create_user ::JSON.parse request.body.read
      { status: 'success', data: { user: user } }.to_json
    end

    def edit_user
      param :id, String, formmat: /\d+/, required: true
      validate_create_user_params false
      permission params[:id].to_i, ['manage_users']
      user = User.update params[:id], JSON.parse(request.body.read)
      { status: 'success', data: { user: user } }.to_json
    end

    def find_user
      param :id, String, format: /\d+/, required: true
      permission params[:id].to_i, ['manage_users']
      user = User.select(User.attribute_names - ['password_digest']).find params[:id]
      [200, { status: 'success', data: { user: user } }.to_json]
    end

    def delete_user
      param :id, String, formmat: /\d+/, required: true
      permission params[:id].to_i, ['manage_users']
      User.delete params[:id]
    end

    def add_permission
      param :permission, String, format: /\w+/, required: true
      permission nil, ['manage_users']
      access = find_permission_by_name params[:permission]
      user = User.find params[:id]
      user.permissions << access
      [200, { status: 'success', data: { user: user } }.to_json]
    end
  end

  helpers UserHelper
end
