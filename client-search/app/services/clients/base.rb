module Clients
  class Base
    attr_reader :clients

    def initialize
      @file_path = "app/services/clients/clients.json".freeze
      @clients = load_clients
    end

    private

    def load_clients
      file_content = Rails.root.join(@file_path).read
      JSON.parse(file_content)
    rescue JSON::ParserError => e
      raise "Invalid JSON format in #{@file_path}: #{e.message}"
    rescue Errno::ENOENT
      raise "File not found: #{@file_path}"
    end
  end
end
