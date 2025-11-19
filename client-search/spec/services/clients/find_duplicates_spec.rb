# frozen_string_literal: true

require "rails_helper"

RSpec.describe Clients::FindDuplicates, type: :services do
  describe "#find_duplicates_by_email" do
    let(:clients_with_duplicate_emails) do
      [
        { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
        { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
        { "id" => 3, "full_name" => "John Done", "email" => "john.doe@gmail.com" }
      ]
    end

    let(:clients_without_duplicate_emails) do
      [
        { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
        { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
      ]
    end

    context "duplicate email is present" do
      before do
        allow_any_instance_of(described_class).to receive(:clients).and_return(clients_with_duplicate_emails)
      end
      it "returns duplicate client json" do
        expect(described_class.call).to eq({ "john.doe@gmail.com" => [ { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
                                                                         { "id" => 3, "full_name" => "John Done", "email" => "john.doe@gmail.com" } ] })
      end
    end

    context "duplicate email is not present" do
      before do
        allow_any_instance_of(described_class).to receive(:clients).and_return(clients_without_duplicate_emails)
      end
      it "returns blank" do
        expect(described_class.call).to eq({})
      end
    end
  end
end
