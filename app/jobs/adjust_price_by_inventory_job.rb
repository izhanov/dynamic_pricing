# frozen_string_literal: true

class AdjustPriceByInventoryJob
  include Sidekiq::Job

  def perform
    products_ids = Product.all.pluck(:id).map(&:to_s).zip
    UpdateProductPriceByInventoryJob.perform_bulk(products_ids)
  end
end
