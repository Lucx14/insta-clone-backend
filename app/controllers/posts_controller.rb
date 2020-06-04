class PostsController < ApplicationController
  include ExceptionHandler
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = Post.all
    render json: @posts, status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def create
    @post = current_user.posts.create!(post_params)
    render json: @post, status: :created
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
    params.permit(:caption)
  end
end
