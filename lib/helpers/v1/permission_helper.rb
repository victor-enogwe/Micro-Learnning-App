# Sinatra DSL
module Sinatra
  # Api permissions helper
  module PermissionHelper
    def permission(creator_id, permissions = [])
      scopes, user = request.env.values_at :scopes, :user
      print scopes
      owner = creator_id == user['id']
      rights = scopes.to_set.superset?(permissions.to_set)
      halt 401, { status: 'error', message: 'access denied' }.to_json unless owner || rights
    end

    def find_permission_by_name(name)
      Permission.find_by_name name
    end
  end

  helpers PermissionHelper
end
