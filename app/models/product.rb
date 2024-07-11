# frozen_string_literal: true

class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :category, type: String
  field :default_price, type: BigDecimal
  field :qty, type: Integer
  field :rank, type: BigDecimal, default: 0.0

  has_one :product_dynamic_price, dependent: :destroy

  def decrement_qty!(qty = 1)
    update_attributes!(qty: self.qty - qty)
  end

  def current_price
    [
      default_price,
      product_dynamic_price.price_by_demand,
      product_dynamic_price.price_by_inventory_level,
      product_dynamic_price.price_by_competition
    ].max
  end
end
