# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'activerecord'
gem 'bcrypt'
gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
gem 'json-schema'
gem 'jwt'
gem 'pg'
gem 'rack'
gem 'rack-contrib'
gem 'rack-parser'
gem 'rack-protection'
gem 'rake'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'sinatra-param'
gem 'slim'

group :development do
  gem 'rubocop'
  gem 'ruby-prof'
  gem 'shotgun'
end

group :test do
  gem 'rspec'
end

group :development, :test do
  gem 'dotenv'
end
