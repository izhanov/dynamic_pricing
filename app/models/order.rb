# frozen_string_literal: true

class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: Integer
  field :note, type: String
  field :status, type: String, default: "pending"
  field :items, type: Array
end
