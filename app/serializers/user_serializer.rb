class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email, :post_count, :follower_count, :followed_count, :following
  has_many :posts

  def post_count
    object.post_count
  end

  def follower_count
    object.follower_count
  end

  def followed_count
    object.followed_count
  end

  def following
    scope[:profile_owner].followed_by?(scope[:current_user])
  end
end
