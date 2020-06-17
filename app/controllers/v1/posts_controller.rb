module V1
  class PostsController < ApplicationController
    include ExceptionHandler
    before_action :set_post, only: %i[show update destroy]

    def index
      # @posts = Post.where.not(user_id: current_user.id)
      @posts = Post.all
      render json: @posts, each_serializer: PostSerializer, scope: {
        current_user: current_user
      }, status: :ok
    end

    def feed
      @posts = current_user.recent_followed_feed
      render json: @posts, each_serializer: PostSerializer, scope: {
        current_user: current_user
      }, status: :ok
    end

    def show
      render json: @post, each_serializer: PostSerializer, scope: {
        current_user: current_user
      }, status: :ok
    end

    def create
      @post = current_user.posts.create!(post_params)
      render json: @post, each_serializer: PostSerializer, scope: {
        current_user: current_user
      }, status: :created
    end

    def update
      @post.update(post_params)
      head :no_content
    end

    def destroy
      @post.destroy
      head :no_content
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.permit(:caption, :image)
    end
  end
end
