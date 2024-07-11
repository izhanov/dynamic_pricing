# frozen_string_literal: true

require "rails_helper"

RSpec.describe PriceRules::CompetitorPrice do
  describe "#adjust" do
    it "updates product_dynamic_price with competitor price" do
      product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 10)

      product_dynamic_price = ProductDynamicPrice.create!(
        product: product,
        price_by_demand: 13,
        price_by_inventory_level: 18,
        price_by_competition: 11
      )
      competitor_price = 15

      described_class.new(product).adjust(competitor_price)

      expect(product_dynamic_price.reload.price_by_competition).to eq(competitor_price)
    end
  end
end
