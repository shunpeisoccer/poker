require 'rails_helper'

#class CardsServiceTest < ActiveSupport::TestCase
# test "the truth" do
#   assert true
# end
#end

describe Cards do
  before do
    @cards = Cards.new(card: nil, api_card: nil)
  end
  describe "#judge" do
    context "正常系" do
      context "ストレートフラッシュ" do
        it "straightflush" do
          @cards.card = "H1 H2 H3 H4 H5"
          @cards.judge
          expect(@cards.hand[:name]).to eq("ストレートフラッシュ")
        end
      end
      context "ストレート" do
        it "straight" do
          @cards.card = "H1 D2 H3 S4 H5"
          @cards.judge
          expect(@cards.hand[:name]).to eq("ストレート")
        end
      end
      context "フラッシュ" do
        it "flush" do
          @cards.card = "H1 H9 H3 H7 H5"
          @cards.judge
          expect(@cards.hand[:name]).to eq("フラッシュ")
        end
      end
      context "フルハウス" do
        it "fullhouse" do
          @cards.card = "H1 D1 S1 H7 D7"
          @cards.judge
          expect(@cards.hand[:name]).to eq("フルハウス")
        end
      end
      context "フォー・オブ・ア・カインド" do
        it "four_of_a_kind" do
          @cards.card = "H1 D1 S1 C1 H5"
          @cards.judge
          expect(@cards.hand[:name]).to eq("フォー・オブ・ア・カインド")
        end
      end
      context "スリー・オブ・ア・カインド" do
        it "three_of_a_kind" do
          @cards.card = "H1 S1 D1 H3 H5"
          @cards.judge
          expect(@cards.hand[:name]).to eq("スリー・オブ・ア・カインド")
        end
      end
      context "ツーペア" do
        it "twopair" do
          @cards.card = "H1 D1 H3 H7 D7"
          @cards.judge
          expect(@cards.hand[:name]).to eq("ツーペア")
        end
      end
      context "ワンペア" do
        it "onepair" do
          @cards.card = "H1 D1 H3 H7 H5"
          @cards.judge
          expect(@cards.hand[:name]).to eq("ワンペア")
        end
      end
      context "ハイカード" do
        it "highcard" do
          @cards.card = "H1 H9 D3 C2 H5"
          @cards.judge
          expect(@cards.hand[:name]).to eq("ハイカード")
        end
      end
    end
    context "異常系" do
      context "ユーザが不正なデータを登録してきた場合" do
        context "重複したデータを登録してきた場合" do
          it "valid_unique" do
            @cards.card = "H1 H1 D3 D4 H5"
            @cards.judge
            expect(@cards.error).to eq("カードが重複しています。")
          end
        end
        context "５つのカードを登録していない場合" do
          it "valid_size" do
            @cards.card = "H1 H2 D3 D4 "
            @cards.judge
            expect(@cards.error).to eq('5つのカード指定文字を半角スペース区切りで入力してください。(例："S1 H3 D9 C13 S11")')
          end
        end
        context "不正文字が含まれている場合" do
          it "valid_form" do
            @cards.card = "H1 H2 D3 D42 H5"
            @cards.judge
            expect(@cards.error).to eq("4番目のカード指定文字が不正です(D42)\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。")
          end
        end

      end

    end
  end


  describe "#new" do
    it "Cards.new" do
      @cards = Cards.new(card: "H1 D1 H3 H7 H5", api_card: nil)
      expect(@cards.card).to eq("H1 D1 H3 H7 H5")
    end
  end


  describe "#api_judge" do
    before do
      @cards = Cards.new(card: nil, api_card: nil)
    end
    context "正常系" do
      it "results" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
        @cards.api_judge
        expect(@cards.result).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => nil, "strength" => 9}, {"card" => "H9 C9 S9 H2 C2", "hand" => "フルハウス", "best" => nil, "strength" => 7}, {"card" => "C13 D12 C11 H8 H7", "hand" => "ハイカード", "best" => nil, "strength" => 1}])
      end
    end
    context "異常系" do
      it "valid_size" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 "]
        @cards.api_judge
        expect(@cards.result).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => nil, "strength" => 9}, {"card" => "H9 C9 S9 H2 ", "msg" => "5つのカード指定文字を半角スペース区切りで入力してください。(例：\"S1 H3 D9 C13 S11\")"},])
      end
      it "valid_form" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 H67 "]
        @cards.api_judge
        expect(@cards.result).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => nil, "strength" => 9}, {"card" => "H9 C9 S9 H2 H67 ", "msg" => "5番目のカード指定文字が不正です(H67)。"},])
      end
      it "valid_unique" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 H9 "]
        @cards.api_judge
        expect(@cards.result).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => nil, "strength" => 9}, {"card" => "H9 C9 S9 H2 H9 ", "msg" => "カードが重複しています。"},])
      end
    end
  end
end

