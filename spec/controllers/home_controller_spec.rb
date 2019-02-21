require 'rails_helper'


describe HomeController do


  describe "GET #top" do
    it "top画面の表示 " do
      #get :top
      expect(assigns(:hands)).to eq nil

    end

  end
  describe "POST #poker" do

    it "assigns the requessted massage to @hands" do

      card = "H10 D5 H5 C3 S5"
      @hands = Cards.new(card)
      @hands.change_card_to_numbers_and_suits
      expect(@hands.numbers).to match_array(["10","5","5","3","5"])
      expect(@hands.suits).to match_array(["H","D","H","C","S"])

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

    it "valid_size" do
      card2 = "H10 D5 C3 S5"
      @hands = Cards.new(card2)
      @hands.change_card_to_numbers_and_suits
      @hands.valid_size
      expect(@hands.error).to eq("5つのカード指定文字を半角スペース区切りで入力してください。")
    end

    it "valid_form"do
      card3 = "H10 D5 H5 C33 S4"
      @hands = Cards.new(card3)
      @hands.change_card_to_numbers_and_suits
      @hands.valid_form
      expect(@hands.error).to eq("4番目のカード指定文字が不正です(C33)半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。")
    end

    it "valid_unique" do
      card4 = "H10 D5 C3 H10 S4"
      @hands = Cards.new(card4)
      @hands.change_card_to_numbers_and_suits
      @hands.valid_unique
      expect(@hands.error).to eq("カードが重複しています。")

    end
  end

end
