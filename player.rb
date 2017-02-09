require_relative 'deck'
require 'pry'

class Player
  attr_accessor :name, :deck, :wins
  @@players = []

  def initialize(name, wins=0)
    @name = name
    @wins = wins
    @deck = []
    @@players << self
  end

  class << self

    def all
      @@players
    end

    def first
      @@players[0]
    end

    def second
      @@players[1]
    end

    def shuffle
      self.first.deck.shuffle!
      self.second.deck.shuffle!
    end

    def draw
      [ self.first.deck.draw!, self.second.deck.draw! ]
    end

  end

end

Players = Player
