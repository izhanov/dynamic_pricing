# frozen_string_literal: true

require "rails_helper"

RSpec.describe Product, type: :model do
  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:category).of_type(String) }
  it { is_expected.to have_field(:default_price).of_type(BigDecimal) }
  it { is_expected.to have_field(:qty).of_type(Integer) }
end
