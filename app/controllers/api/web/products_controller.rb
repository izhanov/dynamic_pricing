# frozen_string_literal: true

module API
  module Web
    class ProductsController < BaseController
      def index
        @products = Product.all
      end

      def show
        @product = Product.find(params[:id])
      end
    end
  end
end
