require 'sinatra/base'

# user helper
module Sinatra
  # user controller class
  module UserController
    def validate_create
      param :fname, String, required: true, format: /[A-Za-z]{2,20}/
      param :lname, String, required: true, format: /[A-Za-z]{2,20}/
      param :email, String, required: true, format: URI::MailTo::EMAIL_REGEXP
      param :password, String, required: true, format: /[A-Za-z]{7,20}/
    end

    def create_user(user)
      user = User.create user
      user_role = Role.find_by_name 'user'
      user.permissions << user_role.permissions.all
      user
    end

    def find_user_by_id(id)
      User.find_by_id id
    end

    def find_user_by_email(email)
      User.joins(:users_permissions).where({ email: email })
    end

    def update_user(payload)
      User.update payload
    end

    # route methods
    def register_user
      validate_create
      user = create_user JSON.parse request.body.read
      { status: 'success', data: { user: user } }.to_json
    end

    def edit_user
      validate_create
      update_user JSON.parse request.body.read
    end

    def find_user
      param :id, Numeric, required: true
      find_by_id param[:id]
    end

    def delete_user
      param :id, Numeric, required: true
      User.destroy param[:id]
    end
  end

  helpers UserController
end
