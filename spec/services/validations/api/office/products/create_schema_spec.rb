# frozen_string_literal: true

require "rails_helper"

RSpec.describe Validations::API::Office::Products::CreateSchema do
  it "requires name, category, default_price, and qty" do
    result = subject.call({})

    expect(result.errors.to_h).to eq(
      name: ["is missing"],
      category: ["is missing"],
      default_price: ["is missing"],
      qty: ["is missing"]
    )
  end

  it "requires name, category to be a string" do
    result = subject.call(name: 1, category: 1)

    expect(result.errors.to_h).to include(name: ["must be a string"])
    expect(result.errors.to_h).to include(category: ["must be a string"])
  end


  it "requires default_price to be a decimal" do
    result = subject.call(default_price: "slkdf")

    expect(result.errors.to_h).to include(default_price: ["must be a decimal"])
  end

  it "requires qty to be an integer" do
    result = subject.call(qty: "slkdf")

    expect(result.errors.to_h).to include(qty: ["must be an integer"])
  end
end
