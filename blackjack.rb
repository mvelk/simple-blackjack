class Game

  def initialize
    @player_hand = []
    @dealer_hand = []
    @player_stays = false
    @dealer_stays = false
  end

  def deal_hands
    2.times do
      @player_hand << @deck.pop
      @dealer_hand << @deck.pop
    end
  end

  def make_deck
    @deck = ((1..10).to_a + [10,10,10,'A'] ) * 4
  end

  def shuffle_cards
    @deck.shuffle!
  end

  def over?
    sum_hand(@player_hand) > 21 || sum_hand(@dealer_hand) > 21 || (@player_stays && @dealer_stays)
  end

  def deal_card(hand)
    hand << @deck.pop
  end

  def sum_hand(hand)
    return hand.reduce(:+) unless hand.include?('A')
    sum_without_ace = hand.select {|card| card.is_a?(Integer)}.reduce(:+)
    sum_without_ace > 10 ? sum_without_ace + 1 : sum_without_ace + 11
  end

  def player_get_move
    return "stay" if @player_stays
    loop do
      puts "Your hand is #{@player_hand}."
      puts "Would you like to hit or stay?"
      move = gets.chomp
      return move if move.match(/^(hit|stay)$/)
    end
  end

  def dealer_get_move
    return "hit" if sum_hand(@dealer_hand) < 17
    "stay"
  end

  def announce_winner
    player_sum = sum_hand(@player_hand)
    dealer_sum = sum_hand(@dealer_hand)
    puts "Your hand: #{@player_hand} Dealer hand: #{@dealer_hand}"
    puts "You have #{player_sum}. The dealer has #{dealer_sum}"
    if (player_sum > dealer_sum && player_sum <= 21)
      puts "You win."
    elsif (dealer_sum > 21 && player_sum <= 21)
      puts "Dealer busted. You win."
    elsif (dealer_sum > 21 && player_sum > 21)
      puts "You and dealer both busted. Dealer wins."
    elsif (dealer_sum == player_sum)
      puts "It's a tie."
    else
      puts "Dealer wins."
    end
  end

  def play_turn
    d_move = dealer_get_move
    p_move = player_get_move

    if p_move == "hit"
      deal_card(@player_hand)
      puts "You hit."
    else
      @player_stays = true
      puts "You stay."
    end

    if d_move == "hit"
      deal_card(@dealer_hand)
      puts "Dealer hits."
    else
      @dealer_stays = true
      puts "Dealer stays."
    end
  end

  def play_hand
    make_deck
    shuffle_cards
    deal_hands
    until over?
      play_turn
      puts "*" * 30
      sleep(1)
    end
    announce_winner
  end

end

if __FILE__ == $PROGRAM_NAME
  blackjack = Game.new
  blackjack.play_hand
end
