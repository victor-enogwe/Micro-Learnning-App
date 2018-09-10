# frozen_string_literal: true

class UserHelper
  include Sinatra::UserHelper
end

RSpec.describe UserHelper do
  user_helper = described_class.new

  describe '.create_user' do
    context 'when user does not exist' do
      it 'should create a new user' do
        email = 'johndoe@gmail.com'
        user = attributes_for(:user, new_email: email)
        user_id = JSON.parse(user_helper.create_user(user)[1])['data']['user']['id']
        expect(user_id).to be_a_kind_of(Numeric)
      end
    end

    context 'when user exists' do
      it 'should return active record invalid error' do
        user = attributes_for(:user)
        expect { user_helper.create_user(user) }.to raise_exception(
          ActiveRecord::RecordInvalid,
          'Validation failed: Email Email already exists!'
        )
      end
    end
  end

  describe '.find_user_by_email' do
    context 'when email' do
      it 'should find a user ' do
        user = user_helper.find_user_by_email 'johndoe@gmail.com'
        expect(user[:id]).to be_a_kind_of(Numeric)
        expect(user[:email]).to eq 'johndoe@gmail.com'
      end
    end
  end
end
