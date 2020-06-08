class User < ApplicationRecord
  # password encryption
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy

  # define the users followed users
  has_many :follows_as_follower, foreign_key: :follower_id, class_name: :Follow, dependent: :destroy
  has_many :followed, through: :follows_as_follower, class_name: :User

  # define the users followers
  has_many :follows_as_followed, foreign_key: :followed_id, class_name: :Follow, dependent: :destroy
  has_many :followers, through: :follows_as_followed, class_name: :User

  # define the users followed posts
  has_many :followed_posts, through: :followed, source: :posts

  before_save { self.email = email.downcase }

  validates :name, presence: true

  validates :username, presence: true,
                       length: { minimum: 3, maximum: 25 },
                       uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
                    length: { maximum: 105 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  validates :password_digest, presence: true

  # Methods relating to users posts
  def post_count
    posts.length
  end

  # Methods related to follows
  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def follow(other_user)
    follows_as_follower.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    follows_as_follower.find_by(followed_id: other_user.id).destroy
  end

  def follower_count
    followers.length
  end

  def followed_count
    followed.length
  end
end
