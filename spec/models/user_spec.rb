require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    it { is_expected.to respond_to(:followed) }
    it { is_expected.to respond_to(:followers) }
    it { is_expected.to respond_to(:followed_posts) }
    it { is_expected.to respond_to(:followed_by?) }
    it { is_expected.to respond_to(:follow) }
    it { is_expected.to respond_to(:unfollow) }
    it { is_expected.to respond_to(:follower_count) }
    it { is_expected.to respond_to(:followed_count) }
    it { is_expected.to respond_to(:post_count) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_secure_password }
  end

  describe 'validations' do
    before { create(:user, name: 'testUser', username: 'Test', email: 'TEST@email.com', password: 'password') }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(25) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_most(105) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.not_to allow_value('test').for(:email) }
    it { is_expected.to allow_value('testing@email.com').for(:email) }

    it { is_expected.to validate_presence_of(:password_digest) }
  end

  describe 'save email' do
    it 'downcases the email before save' do
      user = build(:user, name: 'test', username: 'test', email: 'TESTNAME@EMAIL.COM', password: 'password')
      user.save
      expect(described_class.last.email).to eq('testname@email.com')
    end
  end

  describe 'posts dependency' do
    it 'deletes all posts when user is deleted' do
      user = create(:user)
      create_list(:post, 3, :with_image, user: user)
      expect { user.destroy }.to change(Post, :count).by(-3)
    end
  end

  describe 'post_count' do
    it 'returns the number of posts' do
      user = create(:user)
      create_list(:post, 3, :with_image, user: user)
      expect(user.post_count).to eq(3)
    end
  end

  describe 'bespoke follow methods' do
    let(:kira) { create(:user) }
    let(:odo) { create(:user) }
    let(:sisko) { create(:user) }
    let(:dax) { create(:user) }

    describe 'followed_by?' do
      before { create(:follow, followed_id: kira.id, follower_id: odo.id) }

      it 'indicates a user followed by other user' do
        expect(kira.followed_by?(odo)).to be(true)
        expect(odo.followed_by?(kira)).to be(false)
      end
    end

    describe 'follow' do
      it 'creates a new follow' do
        expect(kira.followed_by?(odo)).to be false
        odo.follow(kira)
        expect(kira.followed_by?(odo)).to be true
      end
    end

    describe 'unfollow' do
      before do
        odo.follow(kira)
        odo.unfollow(kira)
      end

      it 'removes a follow relationship' do
        expect(kira.followed_by?(odo)).to be false
      end
    end

    describe 'follower count' do
      before do
        odo.follow(kira)
        dax.follow(kira)
        sisko.follow(kira)
      end

      it 'returns the number of followers' do
        expect(kira.follower_count).to eq(4)
      end
    end

    describe 'followed count' do
      before do
        kira.follow(dax)
        kira.follow(sisko)
        kira.follow(odo)
      end

      it 'returns the number of users the user is following' do
        expect(kira.followed_count).to eq(4)
      end
    end
  end
end
