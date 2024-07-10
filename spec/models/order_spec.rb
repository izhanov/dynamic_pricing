# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order, type: :model do
  it { is_expected.to have_field(:user_id).of_type(Integer) }
  it { is_expected.to have_field(:note).of_type(String) }
  it { is_expected.to have_field(:items).of_type(Array) }
  it { is_expected.to have_field(:status).of_type(String).with_default_value_of("pending") }
end
