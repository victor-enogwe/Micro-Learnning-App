require 'sinatra/activerecord/rake'
require './lib/micro_learn'

rake db:create_migration NAME=create_users_table
