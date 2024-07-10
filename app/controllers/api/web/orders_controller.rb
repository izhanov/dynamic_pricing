# frozen_string_literal: true

module API
  module Web
    class OrdersController < BaseController
      def create
        operation = Operations::API::Web::Orders::Create.new
        result = operation.call(order_params.to_h)

        case result
        in Success[order]
          render "api/web/orders/create/success", locals: { order: order }, status: :created
        in Failure[error_code, errors]
          render "api/web/orders/create/failure", locals: { error_code: error_code, errors: errors }, status: :bad_request
        end
      end

      private

      def order_params
        params.require(:order).permit(:user_id, :note, items: [:id, :qty])
      end
    end
  end
end
