# frozen_string_literal: true

namespace :client do
  # rake "client:search[CLIENT_NAME]"
  desc "Search clients"
  task :search, %i[search_value] => :environment do |_, args|
    search_key = "full_name" # searching by name only
    search_value = args[:search_value]

      if search_value.blank?
        puts "Error: search_value is missing. Usage: rake \"client:search[CLIENT_NAME]\""
        next
      end

    clients = Clients::Search.find_by(search_key, search_value)
    puts clients.presence || "No result found"
  end

  # rake "client:find_duplicates"
  desc "Find duplicate clients"
  task find_duplicates: :environment do
    duplicates = Clients::FindDuplicates.call
    puts duplicates.presence || "No duplicates found"
  end
end

