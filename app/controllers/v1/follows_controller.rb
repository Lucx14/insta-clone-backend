module V1
  class FollowsController < ApplicationController
    include ExceptionHandler
    before_action :set_followed_user, only: %i[create destroy]

    def create
      @follow = current_user.follow(@followed_user)
      render json: @follow, status: :created
    end

    def destroy
      current_user.unfollow(@followed_user)
      head :no_content
    end

    private

    def follow_params
      params.require(:follow).permit(:followed_id)
    end

    def set_followed_user
      @followed_user = User.find(params[:follow][:followed_id])
    end
  end
end
