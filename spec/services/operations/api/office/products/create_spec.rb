# frozen_string_literal: true

require "rails_helper"

RSpec.describe Operations::API::Office::Products::Create do
  describe "#call" do
    context "when params are invalid" do
      it "returns failure" do
        params = {name: "Product 1", category: "Category 1"}
        result = subject.call(params)

        expect(result.failure).to(
          match_array([:validation_error, { default_price: ["is missing"], qty: ["is missing"] }])
        )
      end
    end

    context "when params are valid" do
      it "returns success" do
        params = { name: "Product 2", category: "Category 2", default_price: 20.0, qty: 20 }

        result = subject.call(params)
        expect(result).to be_success
        expect(result.value!).to have_attributes(params)
      end

      context "when product already exists" do
        it "returns failure" do
          exist_product = Product.create!(name: "Product 3", category: "Category 3", default_price: 30.0, qty: 30)
          params = { name: "Product 3", category: "Category 3", default_price: 30.0, qty: 30 }
          subject.call(params)

          result = subject.call(params)
          expect(result.failure).to match_array([:database_error, /E11000 duplicate key error collection/])
        end
      end
    end
  end
end
