# frozen_string_literal: true

# frozen_string_literal: true

require "rails_helper"

RSpec.describe PriceRules::InventoryLevels do
  describe "#adjust" do
    context "when inventory level is low" do
      it "updates product_dynamic_price with increased price" do
        product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 40)

        product_dynamic_price = ProductDynamicPrice.create!(
          product: product,
          price_by_demand: 13,
          price_by_inventory_level: 18,
          price_by_competition: 11
        )

        described_class.new(product).adjust
        expected_price = product.default_price * PriceRules::InventoryLevels::LOW_INCREASE_RATE
        expect(product_dynamic_price.reload.price_by_inventory_level).to eq(15)
      end
    end

    context "when inventory level is high" do
      it "updates product_dynamic_price with decreased price" do
        product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 458)

        product_dynamic_price = ProductDynamicPrice.create!(
          product: product,
          price_by_demand: 13,
          price_by_inventory_level: 18,
          price_by_competition: 11
        )

        described_class.new(product).adjust
        expected_price = product.default_price * PriceRules::InventoryLevels::DECREASE_RATE
        expect(product_dynamic_price.reload.price_by_inventory_level).to eq(9)
      end
    end

    context "when inventory level is medium" do
      it "updates product_dynamic_price with increased price" do
        product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 80)

        product_dynamic_price = ProductDynamicPrice.create!(
          product: product,
          price_by_demand: 13,
          price_by_inventory_level: 18,
          price_by_competition: 11
        )

        described_class.new(product).adjust
        expected_price = product.default_price * PriceRules::InventoryLevels::MEDIUM_INCREASE_RATE
        expect(product_dynamic_price.reload.price_by_inventory_level).to eq(12)
      end
    end
  end
end

