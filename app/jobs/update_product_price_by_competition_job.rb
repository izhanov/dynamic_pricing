# frozen_string_literal: true

class UpdateProductPriceByCompetitionJob
  include Sidekiq::Job

  def perform(competitor_product)
    product = Product.find_by(name: competitor_product["name"], category: competitor_product["category"])
    PriceRules::CompetitorPrice.new(product).adjust(competitor_product["price"])
  end
end
