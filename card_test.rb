require 'minitest/autorun'
require_relative 'card'

class CardTest < MiniTest::Test

  def setup
    @mycard = Card.new(12,'K','♣')
    @hercard = Card.new(10,'10','♦')
  end

  def test_comparable
    assert (@mycard <=> @hercard) == 1
  end

end
