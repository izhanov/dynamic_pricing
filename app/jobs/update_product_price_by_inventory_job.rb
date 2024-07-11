# frozen_string_literal: true

class UpdateProductPriceByInventoryJob
  include Sidekiq::Job

  def perform(product_id)
    product = Product.find(product_id)
    PriceRules::InventoryLevels.new(product).adjust
  end
end
