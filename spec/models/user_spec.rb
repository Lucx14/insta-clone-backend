require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
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
      create_list(:post, 3, user: user)
      expect { user.destroy }.to change(Post, :count).by(-3)
    end
  end
end
