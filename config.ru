# frozen_string_literal: true

require_relative 'app'

run app unless ENV['RACK_ENV'] == 'test'
