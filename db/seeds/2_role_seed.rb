def get_permissions
  admin_roles = Permission.all

  teacher_roles = admin_roles.select { |role| [
    'update_profile',
    'delete_profile',
    'create_course',
    'update_course',
    'delete_course',
    'create_topic',
    'update_topic',
    'delete_topic',
  ].include? role[:name] }

  user_roles = admin_roles.select { |role| [
    'update_profile',
    'delete_profile'
  ].include? role[:name] }

  [admin_roles, teacher_roles, user_roles]
end

def create_roles(roles)
  [
    ['admin', roles[0]],
    ['teacher', roles[1]],
    ['user', roles[2]]
  ].each do |role|
    record = Role.find_or_create_by :name => role[0]
    record.permissions <<  role[1]
  end
end

create_roles get_permissions
