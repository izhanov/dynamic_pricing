# frozen_string_literal: true

class ProductDynamicPrice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :price_by_demand, type: BigDecimal, default: 0.0
  field :price_by_inventory_level, type: BigDecimal, default: 0.0
  field :price_by_competition, type: BigDecimal, default: 0.0

  belongs_to :product
  index({ product_id: 1 }, { unique: true })

  def max_price_of_three
    max_of_three = [price_by_demand, price_by_inventory_level, price_by_competition].max
    BigDecimal(max_of_three).round(2, half: :even)
  end

  def average_price_of_three
    average_of_three = [price_by_demand, price_by_inventory_level, price_by_competition].sum / 3
    BigDecimal(average_of_three).round(2, half: :even)
  end
end
