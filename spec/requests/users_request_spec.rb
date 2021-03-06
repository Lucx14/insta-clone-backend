require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /signup' do
    let(:user) { build(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_attributes) { attributes_for(:user, password_confirmation: user.password) }

    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(:created)
      end

      it 'returns a success message' do
        expect(JSON.parse(response.body)['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        # rubocop:disable Layout/LineLength
        expect(JSON.parse(response.body)['message']).to match("Validation failed: Password can't be blank, Name can't be blank, Username can't be blank, Username is too short (minimum is 3 characters), Email can't be blank, Email is invalid, Password digest can't be blank")
        # rubocop:enable Layout/LineLength
      end
    end
  end

  describe 'GET /users/:username' do
    let(:auth_headers) { valid_headers }
    let(:user) { create(:user) }

    before { get "/users/#{username}", params: {}, headers: auth_headers }

    context 'when the record exists' do
      let(:username) { user.username }

      it 'returns the user' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)['username']).to eq(user.username)
      end

      it 'returns a status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      let(:username) { 'invalid_username' }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(JSON.parse(response.body)['message']).to match(/Could not find user/)
      end
    end
  end
end
