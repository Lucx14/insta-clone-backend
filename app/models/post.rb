class Post < ApplicationRecord
  belongs_to :user
  validates :caption, presence: true, length: { minimum: 3, maximum: 200 }
  validates :user_id, presence: true
end
