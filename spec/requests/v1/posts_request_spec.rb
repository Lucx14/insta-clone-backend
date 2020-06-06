require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let!(:posts) { create_list(:post, 10, :with_image, user: user) }
  let(:post_id) { posts.first.id }

  let(:headers) { valid_headers }

  describe 'GET /posts' do
    before { get '/posts', params: {}, headers: headers }

    it 'returns the posts' do
      expect(response.body).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns a status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /posts/:id' do
    before { get "/posts/#{post_id}", params: {}, headers: headers }

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
    let(:image) { FilesTestHelper.png }
    let(:valid_attributes) { { caption: 'Test Caption Testing', image: image } }

    context 'when the request is valid' do
      before { post '/posts', params: valid_attributes, headers: headers }

      it 'creates a post' do
        expect(JSON.parse(response.body)['caption']).to eq('Test Caption Testing')
      end

      it 'returns a status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { caption: nil }.to_json }

      before { post '/posts', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['message']).to match(/Validation failed: Caption can't be blank/)
      end
    end
  end

  describe 'PUT /posts/:id' do
    let(:valid_attributes) { { caption: 'Updated test caption' }.to_json }

    context 'when the record exists' do
      before { put "/posts/#{post_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    before { delete "/posts/#{post_id}", params: {}, headers: headers }

    it 'returns a status code 204' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
