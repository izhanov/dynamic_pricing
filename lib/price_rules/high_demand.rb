# frozen_string_literal: true

module PriceRules
  class HighDemand < Base
    INCREASE_RATE = 1.07
    MAX_INCREASE_PRECENT = 75

    def adjust
      planning_increase_price = product.default_price * INCREASE_RATE
      increase_precent = (planning_increase_price - product.default_price) / product.default_price * 100

      unless increase_precent > MAX_INCREASE_PRECENT
        product_dynamic_price.update_attributes(
          price_by_demand: product.default_price * INCREASE_RATE
        )
      end
    end
  end
end
