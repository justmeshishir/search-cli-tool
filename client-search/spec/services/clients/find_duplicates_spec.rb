# frozen_string_literal: true

require "rails_helper"

RSpec.describe Clients::FindDuplicates, type: :services do
  describe "#find_duplicates_by_email" do
    let(:clients_with_duplicate_emails) do
      [
        { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
        { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
        { "id" => 3, "full_name" => "John Done", "email" => "john.doe@gmail.com" },
        { "id" => 4, "full_name" => "Alex Johnson", "email" => "alex.johnson@hotmail.com" },
        { "id" => 5, "full_name" => "Alex John", "email" => "alex.JOHNSON@hotmail.com" },
        { "id" => 6, "full_name" => "Alex Son", "email" => "ALEX.johnson@hotmail.com" }
      ]
    end

    context "with duplicate emails" do
      it "returns duplicate client json" do
        allow_any_instance_of(described_class).to receive(:clients).and_return(clients_with_duplicate_emails)
        service = described_class.call

        expect(service.count).to eq(2)
        expect(service.keys).to eq([ "john.doe@gmail.com", "alex.johnson@hotmail.com" ])
        expect(service["john.doe@gmail.com"].size).to eq(2)
      end

      it "performs case-insensitive matching" do
        allow_any_instance_of(described_class).to receive(:clients).and_return(clients_with_duplicate_emails)
        service = described_class.call

        expect(service["alex.johnson@hotmail.com"].size).to eq(3)
      end

      it "handles client with leading/trailing whitespace" do
        clients = [
          { "id" => 1, "full_name" => "John Doe", "email" => " john.doe@gmail.com " },
          { "id" => 2, "full_name" => "John Doe", "email" => "john.doe@gmail.com" }
        ]
        allow_any_instance_of(described_class).to receive(:clients).and_return(clients)

        expect(described_class.call.keys).to eq([ "john.doe@gmail.com" ])
      end

      it "handles all clients with same email" do
        clients = [
          { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
          { "id" => 2, "full_name" => "John Noo", "email" => "john.doe@gmail.com" },
          { "id" => 3, "full_name" => "John Yoo", "email" => "john.doe@gmail.com" }
        ]
        allow_any_instance_of(described_class).to receive(:clients).and_return(clients)

        expect(described_class.call.keys).to eq([ "john.doe@gmail.com" ])
      end
    end

    context "without duplicate emails" do
      let(:clients_without_duplicate_emails) do
        [
          { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
          { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
          { "id" => 3, "full_name" => "Alex Johnson", "email" => "alex.johnson@hotmail.com" }
        ]
      end

      it "returns empty when no duplicates exist" do
        allow_any_instance_of(described_class).to receive(:clients).and_return(clients_without_duplicate_emails)

        expect(described_class.call).to eq({})
      end

      it "handles client with nil email" do
        client = [ { "id" => 1, "full_name" => "John Doe", "email" => nil } ]
        allow_any_instance_of(described_class).to receive(:clients).and_return(client)

        expect(described_class.call).to eq({})
      end

      it "handles single client dataset" do
        client = [ { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" } ]
        allow_any_instance_of(described_class).to receive(:clients).and_return(client)

        expect(described_class.call).to eq({})
      end
    end

    context "empty dataset" do
      before do
        allow_any_instance_of(described_class).to receive(:clients).and_return([])
      end

      it "returns empty" do
        expect(described_class.call).to eq({})
      end
    end
  end
end
