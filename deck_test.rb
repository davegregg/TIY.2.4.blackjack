require 'minitest/autorun'
require_relative 'deck'

class DeckTest < MiniTest::Test

  def setup
    @mydeck = Deck.new
  end

  def test_draw!
    assert @mydeck.draw!.is_a? Card
  end

end
