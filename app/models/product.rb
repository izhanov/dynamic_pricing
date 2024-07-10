# frozen_string_literal: true

class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :category, type: String
  field :default_price, type: BigDecimal
  field :qty, type: Integer


  def current_price
  end

  def decrement_qty!(qty = 1)
    update(qty: self.qty - qty)
  end
end
