# frozen_string_literal: true

require "rails_helper"

RSpec.describe Operations::API::Office::Products::Import do
  describe "#call" do
    context "when the file is invalid" do
      it "returns a failure" do
        operation = described_class.new
        file = double("file")

        result = operation.call(file)

        expect(result).to be_failure
        expect(result.failure).to(
          eq([:validation_error, { file: ["must be ActionDispatch::Http::UploadedFile"] }])
        )
      end
    end

    context "when the file is valid" do
      it "returns a success and create products" do
        operation = described_class.new
        file = File.new(Rails.root.join("spec", "fixtures", "files", "inventory.csv"))

        uploaded_file = ActionDispatch::Http::UploadedFile.new(
          tempfile: file,
          filename: "inventory.csv",
          type: "text/csv"
        )

        result = operation.call(uploaded_file)
        expect(result).to be_success
        expect(Product.count).to eq(50)
      end
    end
  end
end
