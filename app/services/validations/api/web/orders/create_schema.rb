# frozen_string_literal: true

module Validations
  module API
    module Web
      module Orders
        class CreateSchema < Validations::API::Base
          schema do
            required(:user_id).filled(:integer)
            required(:note).filled(:string)
            required(:items).value(:array, min_size?: 1).each do
              hash do
                required(:id).filled(:string)
                required(:qty).filled(:integer)
              end
            end
          end
        end
      end
    end
  end
end
