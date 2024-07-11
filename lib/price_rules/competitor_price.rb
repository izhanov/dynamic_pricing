# frozen_string_literal: true

module PriceRules
  class CompetitorPrice < Base
    def adjust(competitor_price)
      product_dynamic_price.update_attributes!(
        price_by_competition: competitor_price
      )
    end
  end
end
