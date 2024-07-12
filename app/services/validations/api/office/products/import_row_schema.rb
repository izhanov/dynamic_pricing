# frozen_string_literal: true

module Validations
  module API
    module Office
      module Products
        class ImportRowSchema < Validations::API::Base
          params do
            required(:name).filled(:string)
            required(:default_price).filled(:float)
            required(:category).filled(:string)
            required(:qty).filled(:integer)
          end
        end
      end
    end
  end
end
