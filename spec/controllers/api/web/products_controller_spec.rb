# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::Web::ProductsController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns a success response" do
      product_1 = Product.create!(name: "Product 1", category: "Category 1", default_price: 10, qty: 10)
      product_2 = Product.create!(name: "Product 2", category: "Category 2", default_price: 20, qty: 20)
      product_3 = Product.create!(name: "Product 3", category: "Category 3", default_price: 30, qty: 30)

      product_1_dynamic_price = ProductDynamicPrice.create!(product: product_1, price_by_demand: 13, price_by_inventory_level: 12, price_by_competition: 11)
      product_2_dynamic_price = ProductDynamicPrice.create!(product: product_2, price_by_demand: 23, price_by_inventory_level: 22, price_by_competition: 21)
      product_3_dynamic_price = ProductDynamicPrice.create!(product: product_3, price_by_demand: 33, price_by_inventory_level: 32, price_by_competition: 31)

      expected_response = {
        products: [
          {
            id: product_1.id,
            name: product_1.name,
            category: product_1.category,
            current_price: product_1.current_price,
            qty: product_1.qty,
            rank: product_1.rank
          },
          {
            id: product_2.id,
            name: product_2.name,
            category: product_2.category,
            current_price: product_2.current_price,
            qty: product_2.qty,
            rank: product_1.rank
          },
          {
            id: product_3.id,
            name: product_3.name,
            category: product_3.category,
            current_price: product_3.current_price,
            qty: product_3.qty,
            rank: product_1.rank
          }
        ]
      }

      get :index, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response.to_json)
    end
  end

  describe "GET #show" do
    context "when the product exists" do
      it "returns the product" do
        product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 10)
        product_dynamic_price = ProductDynamicPrice.create!(
          product: product, price_by_demand: 13, price_by_inventory_level: 12, price_by_competition: 11
        )
        get :show, params: { id: product.id }, as: :json

        expected_response = {
          product: {
            id: product.id,
            name: product.name,
            category: product.category,
            current_price: product.current_price,
            qty: product.qty,
            rank: product.rank
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end
end
