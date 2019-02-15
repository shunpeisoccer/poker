class Cards
  include ActiveModel::Validations

  YAKU = ["ハイカード","ワンペア","ツーペア","スリー・オブ・ア・カインド","ストレート","フラッシュ","フルハウス","フォー・オブ・ア・カインド","ストレートフラッシュ"]

  attr_accessor :card , :hand ,:numbers , :suits ,:tramp ,:error

  validates :card, format: /\A[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\s[HDSC]([1-9]|[1][0-3])\Z/
  #validates :tranp, unless: :uniqueness?

  def uniqueness?
    self.tramp.uniq.size == 5

  end

  def initialize(card)
    @card = card
    @hand = nil
    @numbers = nil
    @suits = nil
    @tramp = nil
    @error = nil
  end

  def change
    @tramp = self.card.split
    self.suits = []
    self.numbers = []

    @tramp.each do |t|
      self.suits.push t[0]
      self.numbers.push t[1|1..2]
    end
  end

  def pair(numbers)
    numbers.group_by { |r| r }.map{|key,value|value.size}.sort.reverse
  end
  def straight?(numbers)
    numbers.map!{|n|n.to_i}
    (numbers.map{|n|n+1} & numbers).size== 4
  end
  def flush?(suits)
    suits.uniq.size == 1
  end
  def check(numbers,suits)
    case pair(numbers)
    when [2, 1, 1, 1]
      self.hand = YAKU[1]
    when [2, 2, 1]
      self.hand = YAKU[2]
    when [3, 1, 1]
      self.hand = YAKU[3]
    when [3, 2]
      self.hand = YAKU[6]
    when [4, 1]
      self.hand = YAKU[7]
    else
      case [straight?(numbers), flush?(suits)]
      when [true, false]
        self.hand = YAKU[4]
      when [false, true]
        self.hand = YAKU[5]
      when [true, true]
        self.hand = YAKU[8]
      else
        self.hand = YAKU[0]
      end
      self.hand
    end

  end

end
