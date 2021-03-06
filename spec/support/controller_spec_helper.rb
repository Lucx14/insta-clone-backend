module ControllerSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired token from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers
    {
      'Authorization' => token_generator(user.id),
      'Content-Type' => 'application/json'
    }
  end

  # return invalid headers
  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type' => 'application/json'
    }
  end

  def v2_headers
    {
      'Authorization' => token_generator(user.id),
      'Content-Type' => 'application/json',
      'Accept' => 'application/vnd.posts.v2+json'
    }
  end

  def fetch_image
    image_path = "#{::Rails.root}/storage/defaults/default_post_image.png"
    {
      io: File.open(image_path),
      filename: 'default_post_image.png',
      content_type: 'image/png'
    }
  end
end
