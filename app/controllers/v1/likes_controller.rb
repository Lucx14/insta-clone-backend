module V1
  class LikesController < ApplicationController
    before_action :set_like, only: %i[destroy]

    def create
      @like = current_user.likes.create!(like_params)
      render json: @like, status: :created
    end

    def destroy
      @like.destroy
      head :no_content
    end

    private

    def like_params
      params.permit(:post_id)
    end

    def set_like
      @like = Like.find(params[:id])
    end
  end
end
