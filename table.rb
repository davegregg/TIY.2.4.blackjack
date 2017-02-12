require_relative 'deck'

class Hand < Array
  include Comparable

  def total
    self.reduce(0){ |total,card| total + card.value }
  end

  def +(other)
    self << other
  end

end

class Table < Hash
  attr_accessor :deck

  def initialize( deck )

    self[:player] = Hand[ deck.draw!, deck.draw! ]
    self[:dealer] = Hand[ deck.draw!, deck.draw! ]

  end

end
