module Validators
  extend ActiveSupport::Concern
  ERROR = {size_error: '5つのカード指定文字を半角スペース区切りで入力してください。(例："S1 H3 D9 C13 S11")',
           form_error: "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。",
           unique_error: "カードが重複しています。"
  }

  def valid_size?
    if @cards_set.size == 5
      return true
    else
      @error = ERROR[:size_error]
      return false
    end
  end

  def valid_form?
    error_num = []
    @cards_set.each_with_index do |c, i|
      if c !~ /\A[HDSC]([1-9]|[1][0-3])\Z/
        error_num.push("#{i + 1}番目のカード指定文字が不正です(#{c})\n")
      end
    end
    if error_num.empty? == true
      return true
    else
      @error = "#{error_num.join}"+ERROR[:form_error]
          return false
    end

  end

  def valid_unique?
    if @cards_set.uniq.size == 5
      return true
    else
      @error = ERROR[:unique_error]
      return false
    end
  end
end