class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def call
    {
      user: user
    }
  end

  private

  attr_reader :headers

  # 3 check if the user is in the database
  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token

    # handle if user is not found
  rescue ActiveRecord::RecordNotFound => e
    # raise a custom error
    raise(ExceptionHandler::InvalidToken, ("#{Messages::AuthMessages.invalid_token} #{e.message}"))
  end

  # 2. decode the auth token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # 1. check for token in auth header
  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    raise(ExceptionHandler::MissingToken, Messages::AuthMessages.missing_token)
  end
end
