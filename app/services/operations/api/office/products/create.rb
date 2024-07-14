# frozen_string_literal: true

module Operations
  module API
    module Office
      module Products
        class Create < Operations::API::Base
          def call(params)
            validated_params = yield validate(params)
            product = yield commit(validated_params.to_h)
            Success(product)
          end

          private

          def validate(params)
            validation = Validations::API::Office::Products::CreateSchema.new.call(params)
            validation.to_monad
              .or { |failure| Failure[:validation_error, failure.errors.to_h] }
          end

          def commit(params)
            product = Product.create!(params)
            Success(product)
          rescue Mongo::Error::OperationFailure => e
            Failure[:database_error, e.message]
          end
        end
      end
    end
  end
end
