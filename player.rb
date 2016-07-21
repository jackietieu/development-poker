require_relative 'hand'

class Player

  attr_accessor :hand, :round_bet, :pot
  attr_reader :name

  def initialize(name)
    @hand = Hand.new
    @pot = 500
    @round_bet = 0
    @name = name
  end

  def get_mulligan
    puts "Which cards would you like to mulligan"
    eval(gets.chomp)
  end

  def mulligan(index_array)
    new_hand = []

    @hand.cards.each_with_index do |card, i|
      new_hand << card unless index_array.include?(i)
    end

    @hand.cards = new_hand
  end

  def get_bet
    puts "would you like to fold, call, or bet?"
    eval(gets.chomp)
  end
end
