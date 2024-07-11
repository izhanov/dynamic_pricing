# frozen_string_literal: true

module PriceRules
  class Base
    attr_reader :product, :product_dynamic_price

    def initialize(product)
      @product = product
      @product_dynamic_price = product.product_dynamic_price
    end

    def adjust
      raise NotImplementedError, "Subclasses must implement a #adjust method"
    end
  end
end
