class Cards
  include ActiveModel::Validations

  Hand_name = ["ハイカード","ワンペア","ツーペア","スリー・オブ・ア・カインド","ストレート","フラッシュ","フルハウス","フォー・オブ・ア・カインド","ストレートフラッシュ"]

  attr_accessor :card , :hand ,:numbers , :suits ,:cards_set ,:error ,:handnumber ,:best

  validates :card, format: /\A[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\Z/
  #validates :tranp, unless: :uniqueness?

  def unique?
    self.cards_set.uniq.size == 5

  end

  def initialize(card)
    @card = card
    @hand = nil
    @numbers = nil
    @suits = nil
    @cards_set = nil
    @error = nil
    @handnumber = nil
    @best = nil
  end

  def change_card_to_numbers_and_suits
    @cards_set = @card.split
    @suits = []
    @numbers = []

    @cards_set.each do |t|
      @suits.push t[0]
      @numbers.push t[1|1..2]
    end
  end

  def pair(numbers)
    numbers.group_by { |r| r }.map{|key,value|value.size}.sort.reverse
  end
  def straight?(numbers)
    numbers.map!{|n|n.to_i}.sort!
    numbers_pull = numbers.map { |r| r - numbers[0] }
    numbers_pull == [0, 1, 2, 3, 4] || numbers_pull == [0, 9, 10, 11, 12]
  end
  def flush?(suits)
    suits.uniq.size == 1
  end
  def check_hand(numbers,suits)
    case pair(numbers)
    when [2, 1, 1, 1]
      @hand = Hand_name[1]
    when [2, 2, 1]
      @hand = Hand_name[2]
    when [3, 1, 1]
      @hand = Hand_name[3]
    when [3, 2]
      @hand = Hand_name[6]
    when [4, 1]
      @hand = Hand_name[7]
    else
      case [straight?(numbers), flush?(suits)]
      when [true, false]
        @hand = Hand_name[4]
      when [false, true]
        @hand = Hand_name[5]
      when [true, true]
        @hand = Hand_name[8]
      else
        @hand = Hand_name[0]
      end
      @hand
    end

  end

end
