#!/usr/bin/env ruby
require_relative 'player'
require 'tty'
require 'pry'

class Game

  def initialize

    print "\n####################################################\n"
    @prompt = TTY::Prompt.new
    new_game?

  end

  def new_game?

    @start = begin
               @prompt.yes?("\n  Would you like to start a new game of WAR?") {|q| q.default true}
             rescue
               retry
             end || exit

    set
    play

  end

  def set

    Player.new('Piotr')
    Player.new('Yuri')
    Player.first.wins = 0
    Player.second.wins = 0
    Player.first.deck = Deck.new
    Player.second.deck = Deck.new
    Players.shuffle

    @sets = []
    @winning = ''

  end

  def play

    52.times do |round|

      @hand = Players.draw

      case resolve ( @hand )

        when Player.first # wins the hand
          Player.first.wins += 1

        when Player.second # wins the hand
          Player.second.wins += 1

      end

    end

    tally

  end

  def resolve(hand)

      hand[0] > hand[1] ? Player.first : Player.second
      # @sets << { Player1: [ hand[0].face, hand[0].suit ], Player1: [ hand[1].face, hand[1].suit ] }

  end

  def tally

    @winning = Player.first.wins > Player.second.wins ? Player.first : Player.second

    # set_detail = @sets.each do |set|
    #   "#{set}"
    # end

    print "\n  #{@winning.name} won overall with #{@winning.wins} out of 52.\n"

    new_game?

  end

end

Game.new

print "\n"
