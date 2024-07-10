# frozen_string_literal: true

module API
  module Office
    class BaseController < ActionController::API
      include Dry::Monads[:result]
    end
  end
end
