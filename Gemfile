# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'rack'
gem 'rack-protection'
gem 'sinatra'
gem 'slim'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'pg'
gem 'bcrypt'
gem 'jwt'
gem 'rake'

group :development do
	gem 'rubocop'
end

group :test do
  gem "rspec"
end

group :development, :test do
  gem 'dotenv'
end
