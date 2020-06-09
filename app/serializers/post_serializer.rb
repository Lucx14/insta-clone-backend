class PostSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :caption, :most_recent_likes, :like_count, :created_at, :liked_by_current_user, :author

  def author
    {
      id: object.user.id,
      username: object.user.username,
      followed_by_current_user: object.user.followed_by?(scope[:current_user])
    }
  end

  def image_url
    object.image_url
  end

  def like_count
    object.likes.length
  end

  def most_recent_likes
    object.most_recent_likes
  end

  def liked_by_current_user
    object.liked_by?(scope[:current_user])
  end
end
