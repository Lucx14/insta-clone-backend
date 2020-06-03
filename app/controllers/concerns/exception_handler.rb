module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_transaction
  end

  private

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
