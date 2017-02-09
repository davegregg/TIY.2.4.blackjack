require 'pry'

class Card
  attr_accessor :value, :face, :suit

  def initialize(value, face, suit)
    @value, @face, @suit = value, face, suit
  end

  def <(other)
    self.value < other.value
  end

  def >(other)
    self.value > other.value
  end

end
