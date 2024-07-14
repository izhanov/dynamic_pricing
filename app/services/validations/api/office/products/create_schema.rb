# frozen_string_literal: true

module Validations
  module API
    module Office
      module Products
        class CreateSchema < Validations::API::Base
          params do
            required(:name).filled(:string)
            required(:category).filled(:string)
            required(:default_price).filled(:decimal)
            required(:qty).filled(:integer)
          end
        end
      end
    end
  end
end
