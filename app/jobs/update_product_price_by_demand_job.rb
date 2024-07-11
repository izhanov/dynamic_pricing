# frozen_string_literal: true

class UpdateProductPriceByDemandJob
  include Sidekiq::Job

  def perform(product_id)
    product = Product.find(product_id)
    PriceRules::HighDemand.new(product).adjust
  end
end
