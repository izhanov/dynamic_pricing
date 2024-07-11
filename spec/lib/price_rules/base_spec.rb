# frozen_string_literal: true

require "rails_helper"

RSpec.describe PriceRules::Base do
  let(:subject) { described_class.new(product) }

  describe "#adjust" do
    let (:product) { double("product", product_dynamic_price: double("product_dynamic_price")) }

    it "raises NotImplementedError" do
      expect { subject.adjust }.to raise_error(NotImplementedError)
    end
  end
end
