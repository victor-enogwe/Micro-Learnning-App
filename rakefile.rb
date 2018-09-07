# frozen_string_literal: true

require 'rake'
require 'faker'
require 'sendgrid-ruby'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require_relative './lib/jobs/topic_job'

# require the model(s)
Dir.glob(File
  .join(File.expand_path(__dir__), 'db', 'models', '*.rb')).each { |file| require file }

namespace :micro_learn do
  desc 'Setup MicroLearn App Database.'
  task setup_database: %w[db:migrate db:seed]

  desc 'Send Out Topics To Enroled Users'
  task :send_topic do
    send_user_courses = TopicJob.new
    send_user_courses.start
  end
end
