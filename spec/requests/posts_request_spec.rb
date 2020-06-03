require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let!(:posts) { create_list(:post, 10) }
  let(:post_id) { posts.first.id }

  describe 'GET /posts' do
    before { get '/posts' }

    it 'returns the posts' do
      expect(response.body).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /posts/:id' do
    before { get "/posts/#{post_id}" }

    context 'when the record exists' do
      it 'returns the post' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(post_id)
      end

      it 'returns a status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      let(:post_id) { 100 }

      it 'returns a status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Post/)
      end
    end
  end

  describe 'POST /posts' do
    let(:valid_attributes) { { caption: 'Test Caption Testing' } }

    context 'when the request is valid' do
      before { post '/posts', params: valid_attributes }

      it 'creates a post' do
        expect(JSON.parse(response.body)['caption']).to eq('Test Caption Testing')
      end

      it 'returns a status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { caption: nil }.to_json }

      before { post '/posts', params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['message']).to match(/Validation failed: Caption can't be blank/)
      end
    end
  end

  describe 'PUT /posts/:id' do
    let(:valid_attributes) { { caption: 'Updated test caption' } }

    context 'when the record exists' do
      before { put "/posts/#{post_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    before { delete "/posts/#{post_id}" }

    it 'returns a status code 204' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
