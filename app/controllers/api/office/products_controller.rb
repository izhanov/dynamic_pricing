# frozen_string_literal: true

module API
  module Office
    class ProductsController < BaseController
      def index
        @products = Product.all
      end

      def show
        @product = Product.find(params[:id])
      end

      def create
        operation = Operations::API::Office::Products::Create.new
        result = operation.call(product_params.to_h)

        case result
        in Success[product]
          render "api/office/products/create/success", locals: { product: product }, status: :created
        in Failure[error_code, errors]
          render "api/office/products/create/failure", locals: { error_code: error_code, errors: errors }, status: :bad_request
        end
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

      private

      def product_params
        params.require(:product).permit(:name, :category, :default_price, :qty)
      end
    end
  end
end
