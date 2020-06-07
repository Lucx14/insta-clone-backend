class Post < ApplicationRecord
  include Rails.application.routes.url_helpers
  LIKES_LIMIT = 3

  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  belongs_to :user
  validates :caption, presence: true, length: { minimum: 3, maximum: 200 }
  validates :user_id, presence: true

  validates :image, presence: true

  def image_url
    url_for(image)
  end

  def liked_by?(user)
    likers.include?(user)
  end

  def most_recent_likes
    likes.order('created_at DESC').limit(LIKES_LIMIT)
  end
end
