# frozen_string_literal: true

require "rails_helper"

RSpec.describe Operations::API::Web::Orders::Create do
  include ActiveJob::TestHelper

  describe "#call" do
    context "when params are valid" do
      after { clear_enqueued_jobs }

      it "creates an order" do
        product_1 = Product.create!(name: "Product 1", category: "Category 1", default_price: 10, qty: 10)
        product_2 = Product.create!(name: "Product 2", category: "Category 2", default_price: 20, qty: 20)

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
          price_by_competition: 21
        )

        params = {
          user_id: 1,
          note: "Some note",
          items: [
            { id: product_1.id.to_s, qty: 1 },
            { id: product_2.id.to_s, qty: 2 }
          ]
        }

        expect { described_class.new.call(params) }.to change { Order.count }.by(1)
        expect(subject.call(params)).to be_success
      end

      it "enqueues OrderJobs::RankProductsJob" do
        product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 10)
        product_dynamic_price = ProductDynamicPrice.create!(
          product: product,
          price_by_demand: 13,
          price_by_inventory_level: 18,
          price_by_competition: 11
        )

        params = {
          user_id: 1,
          note: "Some note",
          items: [
            { id: product.id.to_s, qty: 1 }
          ]
        }

        expect { described_class.new.call(params) }.to change(RankProductJob.jobs, :size).by(1)
      end

      context "when product qty is not enough" do
        it "doesn't decrement product qty" do
          product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 1)
          product_dynamic_price = ProductDynamicPrice.create!(
            product: product,
            price_by_demand: 13,
            price_by_inventory_level: 18,
            price_by_competition: 11
          )

          params = {
            user_id: 1,
            note: "Some note",
            items: [
              { id: product.id.to_s, qty: 2 }
            ]
          }

          result = described_class.new.call(params)

          expect(product.reload.qty).to eq(1)
          expect(result.value!.items.first[:state]).to eq(:not_enough_qty)
        end
      end

      context "when product qty is enough" do
        it "decrements product qty" do
          product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 10)
          product_dynamic_price = ProductDynamicPrice.create!(
            product: product,
            price_by_demand: 13,
            price_by_inventory_level: 18,
            price_by_competition: 11
          )

          params = {
            user_id: 1,
            note: "Some note",
            items: [
              { id: product.id.to_s, qty: 2 }
            ]
          }

          described_class.new.call(params)

          expect(product.reload.qty).to eq(8)
        end
      end
    end

    context "when params are invalid" do
      it "does not create an order" do
        params = {
          user_id: 1,
          note: "Some note",
          items: []
        }
        expect { described_class.new.call(params) }.not_to change { Order.count }
        expect(subject.call(params)).to be_failure
      end
    end
  end
end
