class Post < ApplicationRecord
  validates :caption, presence: true
end
