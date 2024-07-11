# frozen_string_literal: true

class RankProductJob
  include Sidekiq::Job

  def perform(order_id)
    order = Order.find(order_id)
    items = order.items

    items.each do |item|
      product = Product.find(item[:id])
      product.update_attributes!(rank: product.rank + (item[:requested_qty] / 100.0))
    end
  end
end
