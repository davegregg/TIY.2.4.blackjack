#!/usr/bin/env ruby
require_relative 'dealer'
require_relative 'ColorizeCards'
require 'tty'
require 'pry'

class Game
include ColorizeCards
attr_accessor :deck, :dealer, :first_baseman

  def initialize

    system 'clear' or system 'cls'

    @prompt = TTY::Prompt.new

    setup_procs
    new_game?

  end

  def setup_procs

    @Blackjack = Proc.new{ |player| @table[player].total == 21 }
    @Bust = Proc.new{ |player| @table[player].total > 21 }
    @DealerStays = Proc.new{ @table[:dealer].total >= 16 }
    @PlayerWins = Proc.new{ @table[:player].total >= @table[:dealer].total }

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
      q.default 'Piotr'
      q.validate(/\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/)
    end

    @player = Player.new(player_name)
    @dealer = Dealer.new

    @deck = Deck.new

    @dealer.shuffle(@deck)

    @player.wins = 0
    @dealer.wins = 0

  end

  def play

    if @deck.count >= 4
      @table = @dealer.deal( @deck, true )
    else
      game_over
    end

    round

  end

  def round( call_it=false )

    display_table

    check_hand( call_it )

    hit_or_stay?

  end

  def display_table( expose_all=false )

    system 'clear' or system 'cls'

    puts "\n#{@player.name}'s hand:\n\n"
      display_hand( :player )
      puts "\nTOTAL: #{@table[ :player ].total}"

    puts "\n\n\n#{@dealer.name}'s hand:\n\n"
    expose_all == true ? display_hand( :dealer, true ) : display_hand( :dealer )
    puts "\nTOTAL: #{@table[ :dealer ].total} | DECK COUNT: #{@deck.count}\n\n\n"

  end

  def check_hand( call_it=false )

    if @Blackjack.(:player)
      print "\nBLACKJACK! "
      you_won
    end

    if @Bust.(:player)
      puts "\nBUST! "
      you_lost
    end

    if @Bust.(:dealer)
      puts "\nDealer went BUST! "
      you_won
    end

    if @Blackjack.(:dealer)
      puts "\nDealer got BLACKJACK! "
      you_lost
    end

    if call_it == true

      if @PlayerWins.()

        you_won

      else

        you_lost

      end

    end

  end

  def another_round?

    begin
      @prompt.yes?("\n※ Play another round?") {|q| q.default true}
    rescue
      retry
    end || new_game?

    play

  end

  def hit_or_stay?

    @deck.count == 0 ? staying = 2 : staying = 0

    unless staying == 2

      hit_or_stay = @prompt.select("\n※ Would you like to hit or stay?", %w(Hit Stay))

      if hit_or_stay == 'Stay'
        staying += 1
      else
        @dealer.deal( @deck, false, :player )
      end

      if @DealerStays.()
        staying += 1
      else
        @dealer.deal( @deck, false, :dealer )
      end

    end

    round( (staying == 2) )

  end

  def you_lost

    display_table ( true )
    print "\nYou lost!\n"
    @dealer.wins += 1

    another_round?

  end

  def you_won

    display_table ( true )
    print "\nYou won!\n"
    @player.wins += 1

    another_round?

  end

  def game_over

    @winning = @player.wins > @dealer.wins ? @player : @dealer

    print "\n  #{@winning.name} won with #{@winning.wins} hands.\n"

    new_game?

  end

end

Game.new

print "\n"
