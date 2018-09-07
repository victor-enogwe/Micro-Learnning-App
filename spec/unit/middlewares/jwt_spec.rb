# frozen_string_literal: true

RSpec.describe JwtAuth do
  describe '.auth_credentials' do
    context 'when token' do
      it 'should add user details to headers' do
        user = User.find_by_email ENV['ADMIN_EMAIL']
        scopes = attributes_for(:permission, role: 'admin')[:permissions]
        token = attributes_for(:auth, user: user)[:token]
        env = { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
        fullname = "#{user[:fname]} #{user[:lname]}"
        user_cred = { 'id' => user[:id], 'email' => user[:email], 'fullname' => fullname }
        described_class.new(app).auth_credentials env
        expect(env[:scopes]).to eq scopes
        expect(env[:user]).to eq user_cred
      end
    end
  end
end
