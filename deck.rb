require_relative 'card'

class Deck < Array

  def initialize

    suits = %w( ♠ ♥ ♦ ♣ )
    faces = [ *(2..10), *%w(J Q K A) ]

    suits.each do |suit|
      faces.each do |face|

        self << Card.new(face,suit)

      end
    end

  end

  def draw!
    self.shift
  end

end
