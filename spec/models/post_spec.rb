require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:caption) }
    it { is_expected.to validate_length_of(:caption).is_at_least(3).is_at_most(200) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'liked_by?' do
    it 'indicates a post has been liked by a user' do
      odo = create(:user)
      kira = create(:user)
      post = create(:post, :with_image, user: odo)
      create(:like, post_id: post.id, user_id: kira.id)
      expect(post.liked_by?(kira)).to be(true)
    end
  end
end
