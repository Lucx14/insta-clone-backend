class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_details = AuthenticateUser.new(user.email, user.password).call
    response = {
      message: Messages::AuthMessages.account_created,
      auth_token: auth_details[:auth_token],
      user_id: auth_details[:data][:user_id],
      token_exp: auth_details[:data][:exp]
    }
    render json: response, status: :created
  end

  private

  def user_params
    params.permit(:name, :username, :email, :password, :password_confirmation)
  end
end
