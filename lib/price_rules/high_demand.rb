# frozen_string_literal: true

module PriceRules
  class HighDemand < Base
    INCREASE_RATE = 1.3

    def adjust
      product_dynamic_price.update_attributes(
        price_by_demand: product.default_price * INCREASE_RATE
      )
    end
  end
end
