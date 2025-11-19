module Clients
  class FindDuplicates < Base
    def self.call
      new.find_duplicates_by_email
    end

    def find_duplicates_by_email
      clients.group_by { |client| normalized(client["email"]) }.select { |_, v| v.length > 1 }
    end
  end
end
