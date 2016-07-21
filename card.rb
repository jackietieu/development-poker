class Card
  attr_reader :value, :suit

  def initialize(suit, value)
    @suit, @value = suit, value
  end

end
