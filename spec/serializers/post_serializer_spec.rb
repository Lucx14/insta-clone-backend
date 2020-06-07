require 'rails_helper'

RSpec.describe PostSerializer do
  subject(:serialized_post) { JSON.parse(described_class.new(post).to_json) }

  let(:user) { create(:user) }
  let(:post) { build_stubbed(:post, :with_image, user: user) }

  it {
    expected_keys = %w[id image_url caption most_recent_likes like_count created_at author].sort
    expect(serialized_post.keys.sort).to eq(expected_keys)
  }
end
