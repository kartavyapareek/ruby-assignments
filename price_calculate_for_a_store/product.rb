# frozen_string_literal: true

require 'json'
# Product Class
class Product
  attr_reader :code, :price, :offer_quantity, :offer_price 
  def initialize(code, price, offer_quantity, offer_price)
    @code = code
    @price = price
    @offer_price = offer_price
    @offer_quantity = offer_quantity
  end

  class << self
    def create_products
      file = File.open "product.json"
      data = JSON.load file
      data.each do |key, value|
        Product.new(key, value[0], value[1], value[2])
      end
    end

    def all
      ObjectSpace.each_object(self).to_a
    end

    def search_by_code(code)
      all.select { |product| product.code == code }.first
    end
  end
end
