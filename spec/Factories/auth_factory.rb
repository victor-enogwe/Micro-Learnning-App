# frozen_string_literal: true

FactoryBot.define do
  class AuthHelper
    include Sinatra::AuthHelper
  end
  factory :auth, class: AuthHelper do
    transients do
      user
    end

    auth_helper = AuthHelper.new
    token { auth_helper.create_token auth_helper.payload user }
  end
end
