# frozen_string_literal: true

module Operations
  module API
    class Base
      include Dry::Monads[:result, :do]
    end
  end
end
