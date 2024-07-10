# frozen_string_literal: true

module API
  module Office
    class ProductsController < BaseController
      def show
        @product = Product.find(params[:id])
      end

      def import
        operation = Operations::API::Office::Products::Import.new
        result = operation.call(params[:file])

        case result
        in Success
          render json: { success: true }
        in Failure[error_code, errors]
          render json: { success: false, error: result.failure }, status: :bad_request
        end
      end
    end
  end
end
