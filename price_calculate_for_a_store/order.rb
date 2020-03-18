# frozen_string_literal: true

require_relative 'line_item'
# Order Class
class Order
  def initialize
    puts 'Please enter all the items purchased separated by a comma'
    input_items = gets.chomp
    input_items_arr = input_items.tr(' ', '').split(',')
    line_items = LineItem.final_line_items(input_items_arr)
    print_invoice(line_items)
  end

  def print_invoice(line_items)
    discount = 0
    total = 0
    puts 'Item     Quantity      Price'
    puts '----------------------------'
    line_items.each do |key, value|
      puts "#{key.capitalize}      #{value.quantity}    $#{value.price}"
      total += value.price
      discount += value.discount
    end
    puts "Total price : $#{total}"
    puts "You saved $#{discount} today."
  end
end

Order.new
