# frozen_string_literal: true

module Operations
  module API
    module Web
      module Orders
        class Create < Operations::API::Base
          def call(params)
            validated_params = yield validate(params)
            order = yield create_order(validated_params)
            Success(order)
          end

          private

          def validate(params)
            validation = Validations::API::Web::Orders::CreateSchema.new.call(params)
            validation.to_monad
              .fmap { |success| success.to_h }
              .or { |failure| Failure[:validation_error, failure.errors.to_h] }
          end

          def create_order(params)
            items = prepare_items(params[:items])
            order = Order.create!(
              user_id: params[:user_id],
              note: params[:note],
              items: items
            )

            Success(order)
          end

          def prepare_items(items)
            items.map do |item|
              product = Product.find(item[:id])

              if product_not_enough?(product, item[:qty])
                not_enough_qty_item(product, item[:qty])
              else
                product.decrement_qty!(item[:qty])
                enough_qty_item(product, item[:qty])
              end
            end
          end

          def product_not_enough?(product, qty)
            product.qty < qty
          end

          def not_enough_qty_item(product, requested_qty)
            {
              id: product.id,
              name: product.name,
              qty: product.qty,
              requested_qty: requested_qty,
              price: product.current_price,
              state: :not_enough_qty
            }
          end

          def enough_qty_item(product, requested_qty)
            {
              id: product.id,
              name: product.name,
              qty: product.qty,
              requested_qty: requested_qty,
              price: product.current_price,
              state: :ok
            }
          end
        end
      end
    end
  end
end
