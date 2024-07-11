# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdjustPriceByDemandJob, type: :job do
  describe "#perform" do
    it "enqueued UpdateProductPriceByCompetitionJob" do
      product = Product.create!(
        name: "Product",
        category: "Category",
        default_price: 10,
        qty: 10,
        rank: 10.0
      )

      product_dynamic_price = ProductDynamicPrice.create!(
        product: product,
        price_by_demand: 13,
        price_by_inventory_level: 12,
        price_by_competition: 11
      )

      order = Order.create!(
        user_id: 1,
        note: "Some note",
        items: [
          {
            id: product.id.to_s,
            qty: product.qty,
            requested_qty: 1,
            current_price: product.current_price,
            state: :ok
          }
        ]
      )

      expect {
        subject.perform
      }.to change { UpdateProductPriceByDemandJob.jobs.size }.by(1)
    end
  end
end
