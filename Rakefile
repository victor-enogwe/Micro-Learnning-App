if ENV['RACK_ENV'] == 'development' || !ENV['RACK_ENV']
  require 'dotenv'
  Dotenv.overload
end

require 'faker'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require_relative './lib/jobs/topic_job'

# get the path of the root of the app
APP_ROOT = File.expand_path(__dir__)

# require the model(s)
Dir.glob(File
  .join(APP_ROOT, 'db', 'models', '*.rb')).each { |file| require file }

namespace :micro_learn  do
  desc 'Setup MicroLearn App.'
  task setup: %w[db:migrate db:seed]

  desc 'Send Out Topics To Enroled Users'
  task :send_topic do
    send_user_courses = TopicJob.new
    send_user_courses.start
  end
end
