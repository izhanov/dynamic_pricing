# frozen_string_literal: true

module PriceRules
  class InventoryLevels < Base
    LOW_INVENTORY_THRESHOLD = 50
    MEDIUM_INVENTORY_THRESHOLD = 100
    HIGH_INVENTORY_THRESHOLD = 300

    LOW_INCREASE_RATE = 1.5
    MEDIUM_INCREASE_RATE = 1.2
    DECREASE_RATE = 0.9

    def adjust
      if product.qty < LOW_INVENTORY_THRESHOLD
        update_dynamic_price(product.default_price * LOW_INCREASE_RATE)
      elsif product.qty >= LOW_INVENTORY_THRESHOLD && product.qty < MEDIUM_INVENTORY_THRESHOLD
        update_dynamic_price(product.default_price * MEDIUM_INCREASE_RATE)
      elsif product.qty >= HIGH_INVENTORY_THRESHOLD
        update_dynamic_price(product.default_price * DECREASE_RATE)
      end
    end

    private

    def update_dynamic_price(price)
      product_dynamic_price.update_attributes(
        price_by_inventory_level: price
      )
    end
  end
end
