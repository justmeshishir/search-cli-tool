module Clients
  class FindDuplicates < Base
    def self.call
      new.find_duplicates
    end

    def find_duplicates
      email_hash = clients.each_with_object(Hash.new { |h, k| h[k] = [] }) do |client, hash|
        email = normalized client["email"]
        hash[email] << client if email
      end

      email_hash.select { |_email, clients| clients.size > 1 }&.values
    end
  end
end
