class PostSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :caption, :created_at, :author

  def author
    {
      id: object.user.id,
      username: object.user.username
    }
  end

  def image_url
    object.image_url
  end
end
