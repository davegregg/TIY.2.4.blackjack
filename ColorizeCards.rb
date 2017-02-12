module ColorizeCards
require 'colorize'

  def display_hand( player, expose_all=false )

    color, args = [], []
    rows = { top: [], mid: [], bot: [] }

    unicode_numericals = *('①'..'⑩')
    sliver_l = '▕'.colorize( color: :white ) # \u2595
    sliver_r = '▎'.colorize( color: :white ) # \u258E

    hand = @table[ player ] # expects an array of Card class objects, like:
                            # [#<Card:0x005606768f75f0 @face=2, @suit="♥", @value=2>, #<Card:0x005606768f5340 @face=8, @suit="♦", @value=8>]
    hand.each_with_index do |card, i|

      face, suit = card.face, card.suit
      hole_card = Proc.new{ player == :dealer && i == 1 && expose_all == false }

      face = unicode_numericals[face.to_i - 1] if face.to_i > 0 # only matches non-face cards
      color[i] = (suit == '♥') || (suit == '♦') ? :red : :black # sets the color to be outputted, depending on suit

      args << { color: color[i], background: :white }
      color_card = Proc.new{|s|s.colorize(args[i])}
      color_hole = Proc.new{|s|s.colorize( color: :black, background: :white )}

      fill_card = { top: suit + '  ' + '  ' , # these build the rows which will be printed to the terminal
                    mid: '  ' + face + '  ' , # notice the simulation of rows and columns in our spacing
                    bot: '  ' + '  ' + suit }

      fill_hole = { top: '?'  + '  ' + '  ' ,
                    mid: '  ' + '?'  + '  ' ,
                    bot: '  ' + '  ' + '?'  }

      rows.each do |row, _|

        unless hole_card.() then
          rows[row] << sliver_l + color_card.( fill_card[row] ) + sliver_r
        else
          rows[row] << sliver_l + color_hole.( fill_hole[row] ) + sliver_r
        end

      end

    end

    rows.each do |row, _|

      buffer = '  ' # add left-most margin

      (hand.count).times do |i|
        buffer += '  ' + rows[row][i-1]
      end

      buffer += "\n"
      rows[row] = buffer

    end

    puts rows[:top] +
         rows[:mid] +
         rows[:bot]

  end

end
