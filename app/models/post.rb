class Post < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image
  has_many :likes, dependent: :destroy

  belongs_to :user
  validates :caption, presence: true, length: { minimum: 3, maximum: 200 }
  validates :user_id, presence: true

  validates :image, presence: true

  def image_url
    url_for(image)
  end
end
