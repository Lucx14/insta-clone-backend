class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  # password encryption
  has_secure_password

  # User has an avatar image
  has_one_attached :avatar

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

  # need to prevent user from using a . in their username
  validates :username, presence: true,
                       length: { minimum: 3, maximum: 25 },
                       uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true,
                    length: { maximum: 105 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  validates :password_digest, presence: true

  after_create :attach_default_avatar

  # Methods relating to users posts
  def post_count
    posts.length
  end

  # Methods related to follows
  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def follow(other_user)
    if !other_user.followed_by?(self)
      follows_as_follower.create(followed_id: other_user.id)
    else
      raise(ExceptionHandler::DuplicateRelationship, 'Relationship already exists')
    end
  end

  def unfollow(other_user)
    if other_user.followed_by?(self)
      follows_as_follower.find_by(followed_id: other_user.id).destroy
    else
      raise(ExceptionHandler::MissingRelationship, 'No existing relationship')
    end
  end

  def follower_count
    followers.length
  end

  def followed_count
    followed.length
  end

  def avatar_url
    url_for(avatar)
  end

  private

  # attach default avatar to the user after create
  def attach_default_avatar
    avatar_path = "#{::Rails.root}/storage/defaults/default_avatar.png"
    avatar.attach(io: File.open(avatar_path), filename: 'default_avatar.png', content_type: 'image/png')
  end
end
