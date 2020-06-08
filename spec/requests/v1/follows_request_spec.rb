require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  let(:kira) { create(:user) }
  let(:odo) { create(:user) }

  let(:valid_headers) do
    {
      'Authorization' => token_generator(kira.id),
      'Content-Type' => 'application/json'
    }
  end

  let(:valid_params) do
    {
      'follow' => { followed_id: odo.id }
    }.to_json
  end

  describe 'POST /follows' do
    context 'when the request is valid' do
      before { post '/follow', params: valid_params, headers: valid_headers }

      it 'returns a status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a follow relationship' do
        expect(JSON.parse(response.body)['followed_id']).to eq(odo.id)
      end
    end

    context 'when the relationship already exists' do
      before do
        create(:follow, followed_id: odo.id, follower_id: kira.id)
        post '/follow', params: valid_params, headers: valid_headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a failure message' do
        expect(JSON.parse(response.body)['message']).to match(/Relationship already exists/)
      end
    end

    context 'when the followed user does not exist' do
      let(:invalid_params) do
        {
          'follow' => { followed_id: 1000 }
        }.to_json
      end

      before { post '/follow', params: invalid_params, headers: valid_headers }

      it 'returns a status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when followed user was not provided' do
      before { post '/follow', params: {}, headers: valid_headers }

      it 'returns a status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a failure message' do
        expect(JSON.parse(response.body)['message']).to match(/Couldn't find User without an ID/)
      end
    end
  end

  describe 'DELETE /follow' do
    context 'when valid request' do
      before do
        create(:follow, followed_id: odo.id, follower_id: kira.id)
        delete '/follow', params: valid_params, headers: valid_headers
      end

      it 'returns a status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when followed user was not provided' do
      before do
        create(:follow, followed_id: odo.id, follower_id: kira.id)
        delete '/follow', params: {}, headers: valid_headers
      end

      it 'returns a status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a failure message' do
        expect(JSON.parse(response.body)['message']).to match(/Couldn't find User without an ID/)
      end
    end

    context 'when the users do not have a relationship to delete' do
      before { delete '/follow', params: valid_params, headers: valid_headers }

      it 'returns a status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a failure message' do
        expect(JSON.parse(response.body)['message']).to match(/No existing relationship/)
      end
    end
  end
end
