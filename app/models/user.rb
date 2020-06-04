class User < ApplicationRecord
  # password encryption
  has_secure_password

  has_many :posts, dependent: :destroy
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
end
