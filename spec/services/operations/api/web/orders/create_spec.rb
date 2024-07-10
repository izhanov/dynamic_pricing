# frozen_string_literal: true

require "rails_helper"

RSpec.describe Operations::API::Web::Orders::Create do
  describe "#call" do
    context "when params are valid" do
      it "creates an order" do
        product_1 = Product.create!(name: "Product 1", category: "Category 1", default_price: 10, qty: 10)
        product_2 = Product.create!(name: "Product 2", category: "Category 2", default_price: 20, qty: 20)

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

      context "when product qty is not enough" do
        it "doesn't decrement product qty" do
          product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 1)

          params = {
            user_id: 1,
            note: "Some note",
            items: [
              { id: product.id.to_s, qty: 2 }
            ]
          }

          described_class.new.call(params)

          expect(product.reload.qty).to eq(1)
        end
      end

      context "when product qty is enough" do
        it "decrements product qty" do
          product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 10)

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
