# frozen_string_literal: true

module Validations
  module API
    class Base < Dry::Validation::Contract
      config.messages.backend = :i18n

      config.messages.load_paths << Rails.root.join("config/locales/errors/en.yml")
    end
  end
end
