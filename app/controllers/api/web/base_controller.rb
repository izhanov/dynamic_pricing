# frozen_string_literal: true

module API
  module Web
    class BaseController < ActionController::API
      include Dry::Monads[:result]
    end
  end
end
