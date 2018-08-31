# Sinatra DSL
module Sinatra
  # Api permissions helper
  module PermissionHelper
    def permission(creator_id, permissions = [], super_user = [])
      scopes, user = request.env.values_at :scopes, :user
      status = { status: 'error', message: 'access denied' }.to_json
      owner = creator_id == user['id']
      admin = scopes.to_set.superset?(super_user.to_set)
      instructor = scopes.to_set.superset?(permissions.to_set)
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

    def find_permission_by_name(name)
      Permission.find_by_name name
    end
  end

  helpers PermissionHelper
end
