# frozen_string_literal: true

RSpec.describe 'UserHelper' do
  class UserHelper
    include Sinatra::UserHelper
  end
  describe '.create_user' do
    context 'when user does not exist' do
      it 'should create a new user' do
        user = UserHelper.new.create_user attributes_for(:user)
        print user
      end
    end

    context 'when user exists' do
      it 'should return ann ' do
        user = UserHelper.new.create_user attributes_for(:user)
        print user
      end
    end
  end

  describe '.find_user_by_email' do
    it {}
  end

  describe '.format_find_user_courses' do
    it {}
  end

  describe '.register_user' do
    it {}
  end

  describe '.edit_user' do
    it {}
  end

  describe '.find_user' do
    it {}
  end

  describe '.delete_user' do
    it {}
  end

  describe '.add_permissions' do
    it {}
  end

  describe '.become_instructor' do
    it {}
  end

  describe 'approve_instructor' do
    it {}
  end
end
