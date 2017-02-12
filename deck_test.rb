require 'minitest/autorun'
require_relative 'deck'
require 'pry'

class DeckTest < MiniTest::Test

  def setup
    @mydeck = Deck.new
  end

  def test_draw!
    assert @mydeck.draw!.is_a? Card
  end


end
