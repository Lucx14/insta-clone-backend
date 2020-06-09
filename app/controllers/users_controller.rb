class UsersController < ApplicationController
  include ExceptionHandler

  skip_before_action :authorize_request, only: :create
  before_action :set_profile_owner, only: %i[show]

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

  def show
    if @profile_owner
      render json: @profile_owner, each_serializer: UserSerializer, scope: {
        current_user: current_user,
        profile_owner: @profile_owner
      }, status: :ok
    else
      render json: {
        message: 'Could not find user'
      }, status: :not_found
    end
  end

  private

  def set_profile_owner
    @profile_owner = User.find_by(username: params[:username])
  end

  def user_params
    params.permit(:name, :username, :email, :password, :password_confirmation)
  end
end
