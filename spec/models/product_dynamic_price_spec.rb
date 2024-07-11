# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductDynamicPrice, type: :model do
  it { is_expected.to belong_to(:product) }
  it { is_expected.to have_field(:price_by_competition).of_type(BigDecimal) }
  it { is_expected.to have_field(:price_by_demand).of_type(BigDecimal) }
  it { is_expected.to have_field(:price_by_inventory_level).of_type(BigDecimal) }

  describe "#max_price_of_three" do
    it "returns the maximum price of the three" do
      product_dynamic_price = ProductDynamicPrice.new(
        price_by_demand: 10,
        price_by_inventory_level: 20,
        price_by_competition: 30
      )

      expect(product_dynamic_price.max_price_of_three).to eq(30)
    end
  end

  describe "#average_price_of_three" do
    it "returns the average price of the three" do
      product_dynamic_price = ProductDynamicPrice.new(
        price_by_demand: 10,
        price_by_inventory_level: 20,
        price_by_competition: 30
      )

      expect(product_dynamic_price.average_price_of_three).to eq(20)
    end
  end
end
