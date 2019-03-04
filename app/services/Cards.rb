class Cards
  include ActiveModel::Validations

  HAND_NAME = ["ハイカード","ワンペア","ツーペア","スリー・オブ・ア・カインド","ストレート","フラッシュ","フルハウス","フォー・オブ・ア・カインド","ストレートフラッシュ"]

  attr_accessor :cards , :hand  ,:error  ,:best  ,:api_cards ,:results
  attr_reader :numbers , :suits

  def initialize(card:,api_card:)
    @cards = card
    @api_cards = api_card
    @hand = nil
    @best = nil
    @results = nil
    @error = nil
  end
  def judge
    change_from_card_to_numbers_and_suits
    if valid_size == false
      @hand = nil
    else
      if valid_form == false
        @hand = nil
      else
        if valid_unique == false
          @hand = nil
        else
          judge_hand
        end
      end
    end
  end
  def api_judge
    all_hand = []
    @results = []
    @api_cards.each do |card|
      @cards = card
      change_from_card_to_numbers_and_suits
      if valid_size == true && valid_form == true && valid_unique == true
        judge_hand
        @hand_number = HAND_NAME.find_index(@hand)
        all_hand.push(@hand_number)
        result_true = {"card"=>@cards,"hand"=>@hand,"best"=>nil}
        @results.push(result_true)
      else
        result_false = {"card"=>@cards,"msg"=>@error.gsub(/\n|半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください/,"")}
        @results.push(result_false)
      end
    end
     @results.select.each do |hash|
       if hash["msg"] == nil
          if HAND_NAME.find_index(hash["hand"]) == all_hand.max
            hash["best"] = true
          else
            hash["best"] = false
        end

      end
      @results
     end
  end


private

  def valid_size
    if @cards_set.size == 5
      return true
    else
      @error = '5つのカード指定文字を半角スペース区切りで入力してください。(例："S1 H3 D9 C13 S11"）'
      return false
    end
  end
  def valid_form
     error_num = []
     @cards_set.each_with_index do |c,i|
       if c !~ /\A[HDSC]([1-9]|[1][0-3])\Z/
           error_num.push("#{i+1}番目のカード指定文字が不正です(#{c})\n")
       end
     end
     if error_num.empty? == true
       return true
     else
       @error = "#{error_num.join}半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
       return false
     end

  end

  def valid_unique
    if @cards_set.uniq.size == 5
      return true
    else
      @error = "カードが重複しています。"
      return false
    end
  end



  def change_from_card_to_numbers_and_suits
    @cards_set = @cards.split
    @suits = []
    @numbers = []

    @cards_set.each do |t|
      @suits.push t[0]
      @numbers.push t[1|1..2]
    end
  end

  def pair(numbers)
    numbers.group_by {|c|c}.map{|k,v|v.size}.sort.reverse
  end
  def straight?(numbers)
    numbers.map!{|n|n.to_i}.sort!
    numbers_pull = numbers.map { |r| r - numbers[0] }
    numbers_pull == [0, 1, 2, 3, 4] || numbers_pull == [0, 9, 10, 11, 12]
  end
  def flush?(suits)
    suits.uniq.size == 1
  end
  def judge_hand
    case pair(@numbers)
    when [2, 1, 1, 1]
      @hand = HAND_NAME[1]
    when [2, 2, 1]
      @hand = HAND_NAME[2]
    when [3, 1, 1]
      @hand = HAND_NAME[3]
    when [3, 2]
      @hand = HAND_NAME[6]
    when [4, 1]
      @hand = HAND_NAME[7]
    else
      case [straight?(@numbers), flush?(@suits)]
      when [true, false]
        @hand = HAND_NAME[4]
      when [false, true]
        @hand = HAND_NAME[5]
      when [true, true]
        @hand = HAND_NAME[8]
      else
        @hand = HAND_NAME[0]
      end
      @hand
    end
  end
end




