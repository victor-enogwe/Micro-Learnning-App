require 'sinatra/base'

# sinatra DSL
module Sinatra
  # user routes
  module UserRoutes
    def self.registered(app)
      app.get('/api/v1/user/find/:id') { find_user }
      app.post('/api/v1/user/update') { edit_user }
      app.delete('/api/v1/user/delete') { delete_user }
    end
  end
end
