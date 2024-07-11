# frozen_string_literal: true

# frozen_string_literal: true

require "rails_helper"

RSpec.describe PriceRules::HighDemand do
  describe "#adjust" do
    it "updates product_dynamic_price with increased price" do
      product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 40)

      product_dynamic_price = ProductDynamicPrice.create!(
        product: product,
        price_by_demand: 13,
        price_by_inventory_level: 18,
        price_by_competition: 11
      )

      described_class.new(product).adjust
      expected_price = product.default_price * PriceRules::HighDemand::INCREASE_RATE
      expect(product_dynamic_price.reload.price_by_demand).to eq(expected_price)
    end
  end
end

