# frozen_string_literal: true

require "rails_helper"

RSpec.describe Clients::Search, type: :services do
  describe "#find_by" do
    context "find_by full_name" do
      let(:clients) do
        [
          { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
          { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
          { "id" => 3, "full_name" => "Alex Johnson", "email" => "alex.johnson@hotmail.com" }
        ]
      end

      context "when full name matches" do
        before do
          allow_any_instance_of(described_class).to receive(:clients).and_return(clients)
        end
        it "returns the matching client hash" do
          expect(described_class.find_by("full_name", "John Doe")).to eq([ { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" } ])
        end
      end

      context "when full name does not match" do
        it "returns blank" do
          expect(described_class.find_by("full_name", "John Done")).to eq([])
        end
      end
    end
  end
end
