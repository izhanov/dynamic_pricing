# frozen_string_literal: true

require "rails_helper"

RSpec.describe Validations::API::Office::Products::ImportSchema do
  it "requires a file" do
    result = subject.call({})

    expect(result.errors[:file]).to include("is missing")
  end

  it "must be a ActionDispatch::Http::UploadedFile" do
    result = subject.call(file: "not a file")
    expect(result.errors[:file]).to include("must be ActionDispatch::Http::UploadedFile")
  end

  it "requires a file to be a CSV" do
    temp_file = File.new(Rails.root.join("spec", "fixtures", "files", "invalid.txt"))
    uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: temp_file, filename: "invalid.txt")

    result = subject.call(file: uploaded_file)
    expect(result.errors[:file]).to include("file format is invalid")
  end

  it "requires a file to have the correct headers" do
    temp_file = File.new(Rails.root.join("spec", "fixtures", "files", "invalid_headers.csv"))
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: temp_file,
      filename: "invalid_headers.csv",
      head: "Content-Disposition: form-data; name=\"file\"; filename=\"inventory.csv\"\r\nContent-Type: text/csv\r\n",
      type: "text/csv"
    )

    result = subject.call(file: uploaded_file)
    expect(result.errors[:file]).to include("headers mismatch")
  end
end
