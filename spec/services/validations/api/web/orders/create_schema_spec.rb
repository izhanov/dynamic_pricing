# frozen_string_literal: true

require "rails_helper"

RSpec.describe Validations::API::Web::Orders::CreateSchema do
  it "requires user_id, note, items field" do
    expect(subject.call({}).errors.to_h).to include({
      user_id: ["is missing"],
      note: ["is missing"],
      items: ["is missing"]
    })
  end

  it "requires products to be an array" do
    result = subject.call(items: {})

    expect(result.errors.to_h).to include({
      items: ["must be an array"]
    })
  end

  it "requires products to have id and qty" do
    result = subject.call(items: [{}])

    expect(result.errors.to_h).to include({
      items: { 0 => { id: ["is missing"], qty: ["is missing"] } }
    })
  end
end
