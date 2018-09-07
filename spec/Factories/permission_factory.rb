# frozen_string_literal: true

FactoryBot.define do
  factory :permission, class: Permission do
    transient { role { 'user' } }

    permissions { Role.find_by(name: role).permissions.map { |perm| perm[:name] } }
  end
end
