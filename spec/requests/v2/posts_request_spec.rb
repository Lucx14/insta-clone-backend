require 'rails_helper'

RSpec.describe 'V2::Todos', type: :request do
  let(:user) { create(:user) }

  describe 'GET /posts' do
    before { get '/posts/', params: {}, headers: v2_headers }

    it 'returns a placeholder message' do
      expect(JSON.parse(response.body)['message']).to eq('Hello this is v2!')
    end
  end
end
