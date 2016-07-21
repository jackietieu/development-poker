require_relative 'deck'
require_relative 'player'

class Game

  attr_accessor :game_pot, :deck

  def initialize(players, small_blind)
    @small_blind = small_blind
    @deck = Deck.new
    @players = players
    @current_players = players
    @max_round_bet = 0
    @game_pot = 0
    @initial_turn = true
  end

  def next_turn!
    @current_players.rotate!
  end

  def next_round!(winner)
    winner.pot += @game_pot
    @game_pot = 0
    @players.each { |player| player.round_bet = 0 }
    @max_round_bet = 0
    @players.rotate!
    @players.reject! { |player| player.pot == 0}
    @current_players = @players
  end

  def play
    until over?
      winner = play_round
      next_round!(winner)
    end
  end

  def play_round
    round_setup

    @current_players.length.times do
      play_turn
    end

    until round_over?
      play_turn
    end
    mulligan

    @current_players.length.times do
      play_turn
    end

    until round_over?
      play_turn
    end
    determine_winner
  end

  def mulligan
    @current_players.each do |player|
      puts "#{player.name}: your hand is #{player.hand.to_s}"
      player.mulligan(player.get_mulligan)
      @deck.deal(player.hand) until player.hand.cards.length == 5
    end
  end

  def round_setup
    @deck = Deck.new
    @players.each do |player|
      player.hand = Hand.new
      @deck.deal(player.hand) until player.hand.cards.length == 5
    end
    current_player.pot -= @small_blind
    current_player.round_bet = @small_blind
    next_turn!
    current_player.pot -= 2 * @small_blind
    current_player.round_bet = 2 * @small_blind
    @max_round_bet = 2 * @small_blind
    next_turn!
    @pot = 3 * @small_blind
  end

  def phase_setup

  end

  def play_turn
    puts "#{current_player.name}: your hand is #{current_player.hand.to_s}"
    response = current_player.get_bet
    case response
    when :F
      @current_players.delete(current_player)
    when :C
      call_amount = @max_round_bet - current_player.round_bet
      current_player.round_bet = @max_round_bet
      current_player.pot -= call_amount
      @game_pot += call_amount
      next_turn!
    else
      current_player.round_bet += response
      current_player.pot -= response
      @game_pot += response
      @max_round_bet = current_player.round_bet
      next_turn!
    end
  end

  def round_over?
    @current_players.all? { |player| player.round_bet == @max_round_bet}
  end

  def over?
    @players.length == 1
  end

  def current_player
    @current_players.first
  end

  def determine_winner
    winning_value = 0
    winner = nil
    @current_players.each do |player|
      winner = player if player.hand.strongest_set > winning_value
    end
    winner
  end


end

game = Game.new([Player.new("Gregory"),Player.new("Erica")], 10)
game.play
