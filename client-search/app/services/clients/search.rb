module Clients
  class Search < Base
    def self.find_by(search_key, search_value)
      new.find_by(search_key, search_value)
    end

    def find_by(search_key, search_value)
      clients.filter { |client| normalized(client[search_key]).include?(normalized(search_value)) }
    end
  end
end
