# frozen_string_literal: true

module Operations
  module API
    module Office
      module Products
        class Import < Operations::API::Base
          def call(file)
            validated_file = yield validate(file)
            yield import(validated_file)
            Success(true)
          end

          private

          def validate(file)
            validation = Validations::API::Office::Products::ImportSchema.new.call(file: file)
            validation.to_monad
              .fmap { |success| success.to_h[:file] }
              .or { |failure| Failure[:validation_error, failure.errors.to_h] }
          end

          def import(file)
            CSV.foreach(file, headers: true) do |row|
              Product.create!(
                name: row["NAME"],
                category: row["CATEGORY"],
                default_price: row["DEFAULT_PRICE"],
                qty: row["QTY"]
              )
            end
            Success(true)
          end
        end
      end
    end
  end
end
