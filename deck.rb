require_relative 'card'

class Deck
  attr_reader :stack

  def initialize
    @stack = []
    populate_deck
  end

  def populate_deck
    suits = [:clubs,:hearts,:diamonds,:spades]
    suits.each do |suit|
      (2..14).each { |value| @stack << Card.new(suit, value) }
    end
    @stack.shuffle!
  end


  def deal(hand)
    dealt_card = @stack.pop
    hand.add_card(dealt_card)
  end

end
