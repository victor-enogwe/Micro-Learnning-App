# sinatra DSL
module Sinatra
  # user routes
  module UserRoutes
    def self.registered(app)
      app.post('/users') { register_user  }
      app.get('/users/:id') { find_user }
      app.put('/users/:id/permissions') { add_permission }
      app.patch('/users/:id') { edit_user }
      app.delete('/users/:id') { delete_user }
    end
  end
end
