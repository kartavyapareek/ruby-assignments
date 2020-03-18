# frozen_string_literal: true

require 'net/http'
# RestClient Class
class RestClient
  class << self
    # self block for class method
    def get(url)
      uri = URI(url)
      Net::HTTP.get(uri)
    rescue StandardError => e
      puts e.message
    end
  end
end
