class Card
  include Comparable
  attr_accessor :value, :face, :suit

  def initialize(value = 0, face, suit)
    @face, @suit = face, suit
    @value = calculate_value
  end

  def calculate_value
    val = case @face.to_i
          when *(2..10)
             @face.to_i
          when 0 # catches all face cards
             10
          end
    val = 11 if @face == 'A'
    val
  end

  def <=>(other)
    self.value <=> other.value
  end

  def +(other)
    self.value + other.value
  end
end
