# frozen_string_literal: true

require_relative 'product'
# line_item Class
class LineItem
  attr_accessor :code, :quantity, :price, :discount
  def initialize(code, product)
    @code = code
    @price = product.price
    @quantity = 1
    @discount = 0
  end

  class << self
    def final_line_items(items)
      @line_items = Hash.new
      Product.create_products
      items.each do |item|
        product = Product.search_by_code(item)
        if @line_items.key?(item)
          value = @line_items[item]
          value.quantity = value.quantity + 1
          change_price(product, value)
        else
          @line_items[item] = LineItem.new(item, product)
        end
      end
      @line_items
    end

    def change_price(product, value)
      if product.offer_quantity > 1
        items_without_offer = value.quantity.modulo(product.offer_quantity)
        items_with_offer = (value.quantity/product.offer_quantity).to_i
        value.price = ((product.price * items_without_offer) + (product.offer_price * items_with_offer)).round(2)

        value.discount = ((value.quantity * product.price)- value.price).round(2)
      else
        value.price = (product.price * value.quantity).round(2)
      end
    end
  end
end
