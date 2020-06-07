class PostSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :caption, :most_recent_likes, :like_count, :created_at, :author

  def author
    {
      id: object.user.id,
      username: object.user.username
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
end
