# frozen_string_literal: true

require "rails_helper"

RSpec.describe Clients::Search, type: :services do
  describe "#find_by" do
    context "with valid full_name" do
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
          expect(described_class.find_by("full_name", "John Doe")).to eq([ {
                                                                             "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com"
                                                                           } ])
        end

        it "performs case-insensitive search" do
          expect(described_class.find_by("full_name", "JOHN DOE")).to eq([ {
                                                                             "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com"
                                                                           } ])
        end

        it "finds clients with partial name match" do
          expect(described_class.find_by("full_name", "Joh")).to eq([ {
                                                                        "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com"
                                                                      },
                                                                      {
                                                                        "id" => 3, "full_name" => "Alex Johnson", "email" => "alex.johnson@hotmail.com"
                                                                      } ])
        end

        it "finds clients with just first/last name" do
          expect(described_class.find_by("full_name", "Doe")).to eq([ {
                                                                        "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com"
                                                                      } ])
          expect(described_class.find_by("full_name", "John")).to eq([ {
                                                                         "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com"
                                                                       },
                                                                       {
                                                                         "id" => 3, "full_name" => "Alex Johnson", "email" => "alex.johnson@hotmail.com"
                                                                       } ])
        end

        it "handles search with leading/trailing whitespace" do
          expect(described_class.find_by("full_name", " John Doe ")).to eq([ {
                                                                               "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com"
                                                                             } ])
        end
      end

      context "when full name does not match" do
        it "returns blank" do
          expect(described_class.find_by("full_name", "John Done")).to eq([])
        end
      end
    end

    context "with empty dataset" do
      it "return empty array" do
        allow_any_instance_of(described_class).to receive(:clients).and_return([])

        expect(described_class.find_by("full_name", "John Doe")).to eq([])
      end
    end
  end
end
