require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:user) { create(:user) }
  let!(:posts) { create_list(:post, 3, :with_image, user: user) }
  let(:post_id) { posts.first.id }

  let(:headers) { valid_headers }

  describe 'POST /posts/:post_id/likes' do
    context 'when the request is valid' do
      before { post "/posts/#{post_id}/likes", params: {}, headers: headers }

      it 'returns a status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a like' do
        expect(JSON.parse(response.body)['user_id']).to eq(user.id)
      end
    end
  end

  describe 'DELETE /posts/:post_id/likes/:id' do
    let(:like) { create(:like, user_id: user.id, post_id: post_id) }
    let(:like_id) { like.id }

    before { delete "/posts/#{post_id}/likes/#{like_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
