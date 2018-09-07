# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    transient do
      new_email { ENV['ADMIN_EMAIL'] }
      role { 'user' }
      permissions { attributes_for(:permission, role: role) }
    end

    association :permission, factory: :permissions
    fname { ENV['ADMIN_FIRSTNAME'] }
    lname { ENV['ADMIN_LASTNAME'] }
    email { new_email }
    password { ENV['ADMIN_PASSWORD'] }
  end
end
