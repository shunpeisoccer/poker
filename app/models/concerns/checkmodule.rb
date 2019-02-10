module CheckModule
  YAKU = ["ハイカード","ワンペア","ツーペア","スリー・オブ・ア・カインド","ストレート","フラッシュ","フルハウス","フォー・オブ・ア・カインド","ストレートフラッシュ"]
  def pair(numbers)
    numbers.group_by { |r| r }.map(&:size).sort.reverse
  end
  def straight(numbers)
    sorted = numbers.sort
    steps = sorted.map { |r| r - sorted[0] }
    steps == [0, 1, 2, 3, 4] || steps == [0, 9, 10, 11, 12]
  end
  def flush(suits)
    suits.uniq.size == 1
  end
  def check(numbers,suits)
    case pair(numbers)
      when [2, 1, 1, 1]
        return YAKU[1]
      when [2, 2, 1]
        return YAKU[2]
      when [3, 1, 1]
        return YAKU[3]
      when [3, 2]
        return YAKU[6]
      when [4, 1]
        return YAKU[7]
      else
        case [straight?(numbers), flush?(suits)]
        when [true, false]
          return YAKU[4]
        when [false, true]
          return YAKU[5]
        when [true, true]
          return YAKU[8]
        else
          return YAKU[0]
        end
      end
    end
end
