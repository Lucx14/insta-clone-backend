require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers.except('Authorization') }

  let(:valid_credentials) do
    {
      email: user.email,
      password: user.password
    }.to_json
  end

  let(:invalid_credentials) do
    {
      email: Faker::Internet.email,
      password: Faker::Internet.password
    }.to_json
  end

  describe 'POST /auth/login' do
    context 'when request is valid' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    context 'when request is invalid' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'retuirns a failure message' do
        expect(JSON.parse(response.body)['message']).to match(/Invalid credentials/)
      end
    end
  end
end
