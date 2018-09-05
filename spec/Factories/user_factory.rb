# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    fname { ENV['ADMIN_FIRSTNAME'] }
    lname { ENV['ADMIN_LASTNAME'] }
    email { ENV['ADMIN_EMAIL'] }
    password { ENV['ADMIN_PASSWORD'] }
  end
end
