# frozen_string_literal: true

require "csv"

module Validations
  module API
    module Office
      module Products
        class ImportSchema < API::Base
          schema do
            required(:file).filled(type?: ActionDispatch::Http::UploadedFile)
          end

          rule(:file) do
            key.failure(:file_format) unless value.content_type == "text/csv"

            unless rule_error?
              unless headers_match?(value)
                key.failure(:headers_mismatch)
              end
            end
          end

          private

          def headers_match?(value)
            CSV.read(value, headers: true).headers == %w[NAME CATEGORY DEFAULT_PRICE QTY]
          end
        end
      end
    end
  end
end
