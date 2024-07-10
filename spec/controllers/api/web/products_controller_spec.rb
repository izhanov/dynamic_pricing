# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::Web::ProductsController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns a success response" do
      product_1 = Product.create!(name: "Product 1", category: "Category 1", default_price: 10, qty: 10)
      product_2 = Product.create!(name: "Product 2", category: "Category 2", default_price: 20, qty: 20)
      product_3 = Product.create!(name: "Product 3", category: "Category 3", default_price: 30, qty: 30)
      expected_response = {
        products: [
          {id: product_1.id, name: product_1.name, category: product_1.category, default_price: product_1.default_price, qty: product_1.qty},
          {id: product_2.id, name: product_2.name, category: product_2.category, default_price: product_2.default_price, qty: product_2.qty},
          {id: product_3.id, name: product_3.name, category: product_3.category, default_price: product_3.default_price, qty: product_3.qty}
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
        get :show, params: { id: product.id }, as: :json

        expected_response = {
          product: {
            id: product.id,
            name: product.name,
            category: product.category,
            default_price: product.default_price,
            qty: product.qty
          }
        }
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end
end
