require_relative 'card'

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
    @kicker = nil
  end

  def add_card(card)
    @cards << card
  end

  def strongest_set
    return straight_flush unless straight_flush.nil?
    return four_of_a_kind unless four_of_a_kind.nil?
    return full_house unless full_house.nil?
    return flush unless flush.nil?
    return straight unless straight.nil?
    return three_of_a_kind unless three_of_a_kind.nil?
    return two_pair unless two_pair.nil?
    return one_pair unless one_pair.nil?
    100 + values.max
  end

  def one_pair
    pair_val = values.find { |val| values.count(val) == 2 }
    return 200 + pair_val if pair_val
    nil
  end

  def two_pair
    pair_vals = values.select { |val| values.count(val) == 2 }
    return 300 + pair_vals.max if pair_vals.uniq.length == 2
    nil
  end

  def three_of_a_kind
    tri_val = values.find { |el| values.count(el) == 3 }
    return 400 + tri_val if triple?
    nil
  end

  def straight
    return 500 + values.max if straight?
    nil
  end

  def flush
    return 600 + values.max if flush?
    nil
  end

  def full_house
    if triple?
      tri_val = values.find { |el| values.count(el) == 3 }
      return 700 + tri_val if pair?(tri_val)
    end
    nil
  end

  def triple?
    @cards.any? { |card| values.count(card.value) == 3 }
  end

  def pair?(reject_num)
    pair_val =  values.select { |el| values.count(el) == 2 }
    pair_val.delete(reject_num)
    !pair_val.empty?
  end

  def four_of_a_kind
    if @cards.any? { |card| values.count(card.value) == 4 }
      quad_val = values.find { |el| values.count(el) == 4 }
      return 800 + quad_val
    end

    nil
  end

  def straight_flush
    if flush? && straight?
      return 900 + values.max
    end

    nil
  end

  def flush?
    @cards.all? { |card| card.suit == @cards.first.suit }
  end

  def straight?
    (values.first..values.last).to_a == values
  end

  def to_s
    cardlist = []
    @cards.each { |card| cardlist << [card.value, card.suit] }
    "#{cardlist}"
  end

  def values
    temp_cards = []
    @cards.each do |card|
      temp_cards << card.value
    end

    temp_cards.sort
  end
end
