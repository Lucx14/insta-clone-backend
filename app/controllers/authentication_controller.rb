class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_details = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    render json: {
      auth_token: auth_details[:auth_token],
      user_id: auth_details[:data][:user_id],
      token_exp: auth_details[:data][:exp]
    }
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
