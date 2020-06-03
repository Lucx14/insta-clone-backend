class PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_transaction
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = Post.all
    render json: @posts, status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def create
    @post = Post.create!(post_params)
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

  def not_found(err)
    render json: {
      message: err.message
    }, status: :not_found
  end

  def invalid_transaction(err)
    render json: {
      message: err.message
    }, status: :unprocessable_entity
  end
end
