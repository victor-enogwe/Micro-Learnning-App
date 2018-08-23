user_role = Role.find_by_name 'admin'

[
  {
    :fname => ENV['ADMIN_FIRSTNAME'],
    :lname => ENV['ADMIN_LASTNAME'],
    :email => ENV['ADMIN_EMAIL'],
    :password => ENV['ADMIN_PASSWORD']
  }
].each do |user|
  new_user = User.create user
  new_user.permissions << user_role.permissions.all
end
