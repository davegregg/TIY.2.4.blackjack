require 'minitest/autorun'
require_relative 'card'

class CardTest < MiniTest::Test
  def setup
    @mycard = Card.new(12, 'A', '♣')
    @hercard = Card.new(10, '10', '♦')
  end

  def test_comparable
    #assert (@mycard <=> @hercard) == 1
  end

  def test_calculate_value
    puts @mycard.inspect
    assert @mycard.calculate_value == 11
  end
end
