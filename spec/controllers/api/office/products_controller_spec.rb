# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::Office::ProductsController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns a list of products" do
      Product.create!(name: "Product", category: "Category", default_price: 10, qty: 10)
      get :index, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Product")
    end
  end

  describe "POST #create" do
    context "when the params are invalid" do
      it "returns a failure" do
        post :create, params: { product: { name: "Product" } }, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ success: false, error_code: "validation_error", errors: {category: ["is missing"], default_price: ["is missing"], qty: ["is missing"] } }.to_json)
      end
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

  describe "POST #import" do
    context "when the file is invalid" do
      it "returns a failure" do
        post :import, params: { file: "not a file" }

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ success: false, error: ["validation_error", { file: ["must be ActionDispatch::Http::UploadedFile"] }] }.to_json)
      end
    end

    context "when the file is valid" do
      it "returns a success" do
        inventory_file_path = [
          Rails.root.join("spec", "fixtures", "files", "inventory.csv"),
          "text/csv"
        ]

        file = fixture_file_upload(*inventory_file_path)
        post :import, params: { file: file }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ success: true }.to_json)
      end
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
