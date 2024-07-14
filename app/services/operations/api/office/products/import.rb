# frozen_string_literal: true

module Operations
  module API
    module Office
      module Products
        class Import < Operations::API::Base
          def call(file)
            validated_file = yield validate(file)
            extracted_data = extract_data_from(validated_file)
            validated_data = yield validate_data(extracted_data)
            yield import(validated_data)
            Success(true)
          end

          private

          def validate(file)
            validation = Validations::API::Office::Products::ImportSchema.new.call(file: file)
            validation.to_monad
              .fmap { |success| success.to_h[:file] }
              .or { |failure| Failure[:validation_error, failure.errors.to_h] }
          end

          def extract_data_from(file)
            CSV.foreach(file, headers: true).map do |row|
              {
                name: row["NAME"],
                category: row["CATEGORY"],
                default_price: row["DEFAULT_PRICE"],
                qty: row["QTY"]
              }
            end
          end

          def validate_data(data)
            validation = Validations::API::Office::Products::CreateSchema.new

            failures = collect_failures(data, validation)

            failures.empty? ? Success(data) : Failure[:validation_error, failures]
          end

          def collect_failures(data, validation)
            data.each_with_object([]).with_index do |(row, acc), index|
              result = validation.call(row)

              if result.failure?
                acc << { row_number: index + 1 }.merge(result.errors.to_h)
              end
            end
          end

          def import(data)
            Mongoid.transaction do
              products_insert_result = Product.collection.insert_many(data)
              products_ids = products_insert_result.inserted_ids
              product_dynamic_prices_insert(products_ids)
            end
            Success(true)
          rescue Mongo::Error::BulkWriteError => e
            Failure[:database_error, e.message]
          end

          def product_dynamic_prices_insert(products_ids)

            products = Product.find(products_ids).pluck(:id, :default_price)
            dynamic_prices_data = products.map do |product|
              {
                product_id: product[0],
                price_by_demand: product[1],
                price_by_inventory_level: product[1],
                price_by_competition: product[1]
              }
            end

            ProductDynamicPrice.collection.insert_many(dynamic_prices_data)
          end
        end
      end
    end
  end
end
