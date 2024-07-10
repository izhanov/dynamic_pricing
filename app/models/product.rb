# frozen_string_literal: true

class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :category, type: String
  field :default_price, type: BigDecimal
  field :qty, type: Integer
end
