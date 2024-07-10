# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::Web::OrdersController, type: :controller do
  render_views

  describe "POST #create" do
    context "when the order is valid" do
      it "creates the order" do
        product = Product.create!(name: "Product", category: "Category", default_price: 10, qty: 10)
        order_params = {
          user_id: 1,
          note: "Note",
          items: [
            {id: product.id.to_s, qty: 2 }
          ]
        }
        post :create, params: { order: order_params }, as: :json

        expect(response).to have_http_status(:created)
        expect(Order.count).to eq(1)
        expect(Order.first.user_id).to eq(1)
        expect(Order.first.note).to eq("Note")
      end
    end

    context "when the order is invalid" do
      it "returns an error" do
        order_params = {
          user_id: 1,
          note: "Note",
          items: []
        }
        post :create, params: { order: order_params }, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(Order.count).to eq(0)
      end
    end
  end
end
