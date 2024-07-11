# frozen_string_literal: true

class AdjustPriceByDemandJob
  include Sidekiq::Job

  def perform
    products_ids = Product.where(:rank.gt => 7.0).pluck(:id).map(&:to_s).zip

    UpdateProductPriceByDemandJob.perform_bulk(products_ids)
  end
end
