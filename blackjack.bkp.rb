#!/usr/bin/env ruby
require_relative 'dealer'
require_relative 'ColorizeCards'
require 'colorize'
require 'tty'
require 'pry'

class Game
include ColorizeCards
attr_accessor :deck, :dealer, :first_baseman

  def initialize

    print "\n####################################################\n"
    @prompt = TTY::Prompt.new

    new_game?

  end

  def new_game?

    begin
      @prompt.yes?("\n※ Would you like to start a new game of Blackjack?") {|q| q.default true}
    rescue
      retry
    end || exit

    set
    play

  end

  def set

    player_name = @prompt.ask("\n※ What should I call you?") do |q|
      q.default 'Fidget'
      q.validate(/\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/)
    end

    @player = Player.new(player_name)
    @dealer = Dealer.new

    @deck = Deck.new

    @dealer.shuffle(@deck)

    ### necessary for resetting only (for games after first) ###
    @player.wins = 0
    @dealer.wins = 0

    # @sets = []
    # @winning = ''

  end

  def play

    @table = @dealer.deal( @deck )

    case resolve

      when @player # wins the hand
        @player.wins += 1

      when @dealer # wins the hand
        @dealer.wins += 1

    end

    tally

  end

  def resolve
      blackjack = Proc.new{ @table[:player].total == 21 }

      puts "\n#{@player.name}'s hand:\n\n"
        display_hand(:player)

      puts "\n#{@dealer.name}'s hand:\n\n"
        display_hand(:dealer)

      # simplewin = Proc.new{ @table[:player].total > @table[:dealer].total }
      # simpleloss = Proc.new{ @table[:player].total < @table[:dealer].total }
      #puts "\n#{@player}'s hand: " + red.call(@table[:player][0].face) + red.call(@table[:player][0].suit) + " and  #{@table[:player][1].face}#{@table[:player][1].suit}"

      hit_or_stay = @prompt.select("\n※ Would you like to hit or stay?", %w(Hit Stay))

      if hit_or_stay == 'Hit'

        @dealer.deal( @deck, :player )

        system 'clear' or system 'cls'

      end

      #dealer hits if < 16
      #player choice = hit || stay
      #bust if > 21
      #player autowins if == 21
      #one dealer card 'exposed'
      #player wins if tie
      #must beat the dealer to win
      #finally show all cards on the table


      #all the possible ways for the player to win, in a single condition!, sort of a table of possible ways to win
  end

  def tally

    @winning = @player.wins > @dealer.wins ? @player : @dealer

    # set_detail = @sets.each do |set|
    #   "#{set}"
    # end

    #print "\n  #{@winning.name} won overall with #{@winning.wins} out of 52.\n"

    new_game?

  end

end

Game.new

print "\n"
