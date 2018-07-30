# user controller class
module UserController
  def self.find_user(email, *password)
    user = User.find_by_email email
    user.supplied_password = password if password && user[:id]
    user
  rescue  => error
    print error
  end
end
