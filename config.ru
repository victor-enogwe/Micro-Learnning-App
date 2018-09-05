# frozen_string_literal: true

require_relative 'app'

app unless ENV['RACK_ENV'] == 'test'
