class UserSerializer < ActiveModel::Serializer
  attributes :id, :avatar_url, :name, :username, :email,
             :post_count, :follower_count, :followed_count, :followed_by_current_user
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

  def followed_by_current_user
    scope[:profile_owner].followed_by?(scope[:current_user])
  end

  def avatar_url
    object.avatar_url
  end
end
