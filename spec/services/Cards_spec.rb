require 'rails_helper'

#class CardsServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
#end

describe Cards do
  context "main method "do
  before do
    card = "H10 D5 H5 C3 S5"
    @cards = Cards.new(card: card, api_card: nil)
    @cards.send(:change_from_card_to_numbers_and_suits)
  end
  it "  def change_from_card_to_numbers_and_suits" do
    expect(@cards.numbers).to match_array(["10","5","5","3","5"])
    expect(@cards.suits).to match_array(["H","D","H","C","S"])
  end
=begin
  it "pair" do
     expect(pair(@hands.numbers)).to match_array([3,1,1])
  end

  it "straight" do
     expect(straight?(@hands.numbers)).to eq(false)
  end
  it "flush" do
     expect(flush?(@hands.suits)).to eq(false)
  end
  it "valid_true"do
    card1 = "H10 D5 H5 C3 S5"
    @hands = Cards.new(card1)
    @hands.change_card_to_numbers_and_suits
    if @hands.valid_size ==true && @hands.valid_form != true && @hands.valid_unique == true
      @hands.judge_hand
      expect(@hands.hand).to eq("スリー・オブ・ア・カインド")
    end
  end
=end
  end

  context "valid" do
  it "valid_size" do
    card2 = "H10 D5 C3 S5"
    @cards = Cards.new(card: card2, api_card: nil)
    @cards.send(:change_from_card_to_numbers_and_suits)
    @cards.send(:valid_size)
    expect(@cards.error).to eq('5つのカード指定文字を半角スペース区切りで入力してください。(例："S1 H3 D9 C13 S11"）')
  end

  it "valid_form"do
    card3 = "H10 D5 H5 C33 S4"
    @cards = Cards.new(card: card3, api_card: nil)
    @cards.send(:change_from_card_to_numbers_and_suits)
    @cards.send(:valid_form)
    expect(@cards.error).to eq("4番目のカード指定文字が不正です(C33)\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。")
  end

  it "valid_unique" do
    card4 = "H10 D5 C3 H10 S4"
    @cards = Cards.new(card: card4, api_card: nil)
    @cards.send(:change_from_card_to_numbers_and_suits)
    @cards.send(:valid_unique)
    expect(@cards.error).to eq("カードが重複しています。")
  end
  end

  context "api_judge" do
    before do
      cards = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
      @cards = Cards.new(card: nil, api_card: cards)
      @cards.api_judge
    end
    it "results" do
      expect(@cards.results).to match_array([{"card"=>"H1 H13 H12 H11 H10","hand"=>"ストレートフラッシュ","best"=>true},{"card"=>"H9 C9 S9 H2 C2","hand"=>"フルハウス","best"=>false},{"card"=>"C13 D12 C11 H8 H7","hand"=>"ハイカード","best"=>false}])
    end
  end
end
