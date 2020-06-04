module V2
  class PostsController < ApplicationController
    def index
      render json: { message: 'Hello this is v2!' }, status: :ok
    end
  end
end
