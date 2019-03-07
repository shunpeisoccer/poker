class Cards
  include ActiveModel::Validations
  include Validators

  HAND_NAME = {HIGH_CARD:
                   {strength: 1, name: "ハイカード"},
               ONE_PAIR:
                   {strength: 2, name: "ワンペア"},
               TWO_PAIR:
                   {strength: 3, name: "ツーペア"},
               THREE_OF_A_KIND:
                   {strength: 4, name: "スリー・オブ・ア・カインド"},
               STRAIGHT:
                   {strength: 5, name: "ストレート"},
               FLUSH:
                   {strength: 6, name: "フラッシュ"},
               FULLHOUSE:
                   {strength: 7, name: "フルハウス"},
               FOUR_OF_A_KIND:
                   {strength: 8, name: "フォー・オブ・ア・カインド"},
               STRAIGHT_FLUSH:
                   {strength: 9, name: "ストレートフラッシュ"}

  }

  attr_accessor :card, :api_card, :result
  attr_reader :error, :numbers, :suits, :all_hand, :hand

  def initialize(card:, api_card:)
    @card = card
    @api_card = api_card
  end


  def judge
    change_from_card_to_numbers_and_suits
    if valid_size? == false
      @hand = nil
    else
      if valid_form? == false
        @hand = nil
      else
        if valid_unique? == false
          @hand = nil
        else
          judge_hand
        end
      end
    end
  end

  def api_judge
    @all_hand = []
    @result = []
    @api_card.each do |card|
      @card = card
      change_from_card_to_numbers_and_suits
      if valid_size? == true && valid_form? == true && valid_unique? == true
        judge_hand
        @all_hand.push(@hand[:strength])
        result_true = {"card" => @card, "hand" => @hand[:name], "best" => nil, "strength" => @hand[:strength]}
        @result.push(result_true)
      else
        result_false = {"card" => @card, "msg" => @error.gsub(/\n|半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください/, "")}
        @result.push(result_false)
      end
    end
  end

  private

  def change_from_card_to_numbers_and_suits
    @cards_set = @card.split
    @suits = []
    @numbers = []

    @cards_set.each do |t|
      @suits.push t[0]
      @numbers.push t[1 | 1..2]
    end
  end

  def pair(numbers)
    @pair = numbers.group_by {|c| c}.map {|k, v| v.size}.sort.reverse
  end

  def one_pair?
    @pair == [2, 1, 1, 1]
  end

  def two_pair?
    @pair == [2, 2, 1]
  end

  def three_of_a_kind?
    @pair == [3, 1, 1]
  end

  def four_of_a_kind?
    @pair == [4, 1]
  end

  def fullhouse?
    @pair == [3, 2]
  end

  def straight?(numbers)
    numbers.map! {|n| n.to_i}.sort!
    numbers_pull = numbers.map {|r| r - numbers[0]}
    numbers_pull == [0, 1, 2, 3, 4] || numbers_pull == [0, 9, 10, 11, 12]
  end

  def flush?(suits)
    suits.uniq.size == 1
  end

  def judge_hand
    pair(@numbers)
    if one_pair?
      @hand = HAND_NAME[:ONE_PAIR]
    elsif two_pair?
      @hand = HAND_NAME[:TWO_PAIR]
    elsif three_of_a_kind?
      @hand = HAND_NAME[:THREE_OF_A_KIND]
    elsif fullhouse?
      @hand = HAND_NAME[:FULLHOUSE]
    elsif four_of_a_kind?
      @hand = HAND_NAME[:FOUR_OF_A_KIND]
    else
      case [straight?(@numbers), flush?(@suits)]
      when [true, false]
        @hand = HAND_NAME[:STRAIGHT]
      when [false, true]
        @hand = HAND_NAME[:FLUSH]
      when [true, true]
        @hand = HAND_NAME[:STRAIGHT_FLUSH]
      else
        @hand = HAND_NAME[:HIGH_CARD]
      end
      @hand
    end
  end
end
