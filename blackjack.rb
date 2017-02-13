#!/usr/bin/env ruby
require_relative 'dealer'
require_relative 'ColorizeCards'
require 'tty'
require 'csv'

class Game
include ColorizeCards
attr_accessor :deck, :dealer, :player, :ace_rule, :shoe_rule
StatsFile = ARGV.first || 'player_stats.csv'
@@ace_rule = '11'
@@shoe_rule, @@hard_mode = false, false

  def initialize

    system 'clear' or system 'cls'

    @prompt = TTY::Prompt.new

    new_game?

  end

  def new_game?

    begin
      @prompt.yes?( "\n※ Would you like to start a new game of Blackjack?" ) { |q| q.default true }
    rescue
      retry
    end || exit

    @@ace_rule = @prompt.select( "\n※ Would you like Aces to be valued at 1 or 11?", %w{1 11} )
    @@shoe_rule = begin
                    @prompt.yes?( "\n※ Would you like play from a shoe?" ) { |q| q.default true }
                  rescue
                    retry
                  end || false
    @@hard_mode = begin
                    @prompt.yes?( "\n※ Adventurer Mode rules?" ) { |q| q.default true }
                  rescue
                    retry
                  end || false

    define_rules
    set
    play

  end

  def define_rules

    @Tally = -> who { @table[who].total }
    @Count = -> who { @table[who].count }

    @Blackjack   = -> who { @Tally.(who) == 21 }
    @Bust        = -> who { @Tally.(who) > 21 }
    @SixCardWin  = -> who { @Count.(who) >= 6 && @Tally.(who) <= 21 }
    @DealerStays = -> { @Tally.(:dealer) >= 16 }
    @Tie         = -> { @Tally.(:player) == @Tally.(:dealer) }
    @LargestHand = -> { @Count.(:player) >= @Count.(:dealer) }

    if @@hard_mode == false
      @PlayerWins = -> { @Tally.(:player) >= @Tally.(:dealer) }
    else
      @PlayerWins = -> { @Tally.(:player) > @Tally.(:dealer) }
    end

  end

  def set

    selected_player = ''

    if File.file?( StatsFile ) == true

      loaded_players = CSV.read(StatsFile).drop(1).collect { |game| game[ 1 ] }.uniq
      loaded_players.unshift( '[New Player]' )
      selected_player = @prompt.select( "\n※ Would you like to load a player?", loaded_players )

    end

    unless selected_player == '[New Player]'
      player_name = selected_player
    else
      player_name = @prompt.ask( "\n※ What should I call you?" ) do |q|
        q.default 'Piotr'
        q.validate( /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/ )
      end
    end

    @player = Player.new( player_name )
    @dealer = Dealer.new

    @deck = Deck.new( @@shoe_rule )

    @dealer.shuffle( @deck )

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
    # puts "\nDECK COUNT: #{@deck.count}\n\n\n"
    puts "\nTOTAL: #{@table[ :dealer ].total} | DECK COUNT: #{@deck.count}\n\n\n"

  end

  def check_hand( call_it=false )

    if @Bust.( :player ) || ( @@hard_mode == true && @Blackjack.( :dealer ) )
      you_lost
    end

    if @Blackjack.( :player ) || @Bust.( :dealer ) || @SixCardWin.( :player )
      you_won
    end

    if @Blackjack.( :dealer )
      you_lost
    end

    if call_it == true

      if @PlayerWins.() || ( @Tie.() && @LargestHand.() )
        you_won
      else
        you_lost
      end

    end

  end

  def another_round?

    begin
      @prompt.yes?("\n※ Play another round?") { |q| q.default true }
    rescue
      retry
    end || new_game?

    play

  end

  def hit_or_stay?

    @deck.count == 0 ? staying = 2 : staying = 0

    unless staying == 2

      hit_or_stay = @prompt.select( "\n※ Would you like to hit or stay?", %w(Hit Stay) )

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

  def record_stats( did_player_win )

    CSV.open(StatsFile, 'a') do |csv|
      csv << [ Time.now.to_i, @player.name, @player.wins, did_player_win ]
    end

  end

  def game_over

    did_player_win = false

    if @player.wins > @dealer.wins then
      @winning = @player
      did_player_win = true
    else
      @winning = @dealer
    end

    record_stats( did_player_win )

    print "\n  #{@winning.name} won the game with #{@winning.wins} hands.\n"

    new_game?

  end

  def self.ace_rule=(value)
    @@ace_rule = value
  end

  def self.ace_rule
    @@ace_rule
  end

  def self.shoe_rule=(value)
    @@shoe_rule = value
  end

  def self.shoe_rule
    @@shoe_rule
  end

end

Game.new
