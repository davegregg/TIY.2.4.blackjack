require_relative 'player'
require_relative 'table'

class Dealer < Player
  def initialize(name = 'Dealer')
    @name = name
  end

  def shuffle(deck); 
    deck.shuffle!
  end

  def deal(deck, newtable = false, player = '')
    if newtable == true && deck.count >= 2
      @table = Table.new(deck)
    elsif deck.count >= 1
      @table[player] += deck.draw!
    end
  end
end
