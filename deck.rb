require_relative 'card'
require 'pry'

class Deck < Array
  attr_accessor :faces, :suits, :cards

  def initialize
    @suits = %w( ♠ ♥ ♦ ♣ )
    @faces = [ *('2'..'10'), *%w(J Q K A) ]
    @suits.each do |suit|
      value = 0
      @faces.each do |face|
        value += 1
        self << Card.new(value,face,suit)
      end
    end
  end
  
  def draw!
    drawncard = self.shift
    drawncard
  end

end
