# Sinatra DSL
module Sinatra
  # Api permissions helper
  module PermissionHelper
    def permission(creator_id, permissions = [], super_user = [])
      user = request.env.values_at(:user)[0]
      status = { status: 'error', message: 'access denied' }.to_json
      owner = creator_id == user['id']
      admin = check_permissions super_user
      instructor = check_permissions permissions
      if !super_user.empty? && !owner && permissions.empty?
        halt 401, status unless admin
      elsif !owner && !permissions.empty? && super_user.empty?
        halt 401, status unless instructor
      elsif owner && permissions.empty? && super_user.empty?
        halt 401, status unless owner
      elsif owner && !permissions.empty? && super_user.empty?
        halt 401, status unless owner && instructor
      elsif !owner && !permissions.empty? && !super_user.empty?
        halt 401, status unless admin || instructor
      else
        halt 401, status unless (owner && instructor) || super_user
      end
    end

    def check_permissions(permissions = [])
      scopes = request.env.values_at(:scopes)[0]
      scopes.to_set.superset?(permissions.to_set)
    end

    def find_permission_by_name(name)
      Permission.find_by_name name
    end
  end

  helpers PermissionHelper
end
