# frozen_string_literal: true

class AdjustPriceByCompetitionJob
  include Sidekiq::Job

  def perform
    competitor_response = fetch_competitor_products
    competitor_products = competitor_response.body.map do |product|
      [product]
    end

    UpdateProductPriceByCompetitionJob.perform_bulk(competitor_products)
  rescue Faraday::Error => e
    Rails.logger.error("Error fetching competitor products: #{e.message}")
  end

  private

  def fetch_competitor_products
    conn.get(
      ENV["COMPETITOR_API_URL"],
      {api_key: ENV["COMPETITOR_API_KEY"]}
    )
  end

  def conn
    request_options = {
      request: {
            timeout: 2,
            open_timeout: 1,
            read_timeout: 1,
            write_timeout: 1
      }
    }
    @conn ||= Faraday.new(request_options) do |faraday|
      faraday.request :json
      faraday.response :json
      faraday.response :raise_error
    end
  end
end
