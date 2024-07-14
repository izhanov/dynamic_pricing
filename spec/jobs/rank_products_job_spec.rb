# frozen_string_literal: true

require "rails_helper"

RSpec.describe RankProductJob, type: :job do
  describe "#perform" do
    it "updates product rank" do
      product_1 = Product.create!(name: "Product 1", category: "Category 1", default_price: 10, qty: 10)
      product_2 = Product.create!(name: "Product 2", category: "Category 2", default_price: 10, qty: 20)

      product_1_dynamic_price = ProductDynamicPrice.create!(
        product: product_1,
        price_by_demand: 13,
        price_by_inventory_level: 12,
        price_by_competition: 11
      )

      product_2_dynamic_price = ProductDynamicPrice.create!(
        product: product_2,
        price_by_demand: 23,
        price_by_inventory_level: 22,
      )

      order = Order.create!(
        user_id: 1,
        note: "Some note",
        items: [
          {
            id: product_1.id.to_s,
            qty: product_1.qty,
            requested_qty: 1,
            current_price: product_1.current_price,
            state: :ok
          },
          {
            id: product_2.id.to_s,
            qty: product_2.qty,
            requested_qty: 5,
            current_price: product_2.current_price,
            state: :ok
          }
        ]
      )

      RankProductJob.new.perform(order.id)

      expect(product_1.reload.rank).to eq(0.01)
      expect(product_2.reload.rank).to eq(0.05)
    end
  end
end
