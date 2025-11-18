# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clients::Base, type: :services do
  describe "loads the clients from json file" do
    context "when file path is invalid" do
      it "returns file not found error" do
        file_path = "invalid_file.json"
        expect {
          described_class.new(file_path)
        }.to raise_error(/File not found/)
      end
    end

    context "when file is not in json format" do
      it "returns invalid json format error" do
        file = Tempfile.new(%w[invalid json])
        file.write("This is not a json file.")
        file.close

        expect {
          described_class.new(file.path)
        }.to raise_error(/Invalid JSON format/)
      end
    end

    context "when file is valid JSON" do
      it "returns array of client details hash" do
        file = Tempfile.new(%w[valid json])
        mock_data = [
          {
            "id": 1,
            "full_name": "John Doe",
            "email": "john.doe@gmail.com"
          },
          {
            "id": 2,
            "full_name": "Jane Smith",
            "email": "jane.smith@yahoo.com"
          } ]
        file.write(mock_data.to_json)
        file.close

        service = described_class.new(file.path)
        expect(service.clients).to eq([ { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
                                       { "email" => "jane.smith@yahoo.com", "full_name" => "Jane Smith", "id" => 2 } ])
      end
    end
  end
end
