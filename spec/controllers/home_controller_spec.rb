require 'rails_helper'


describe HomeController do


  describe "GET #top" do
    it "top画面の表示 " do
      #get :top
      expect(assigns(:hands)).to eq nil

    end

  end
  describe "POST #poker" do
    #it "動作" do
      #post :poker
    #end

    it "assigns the requessted massage to @card" do



    end
    it "assigns the requessted massage to @hands" do
      @card = "H10 D5 H5 C3 S5"
      @hands = Cards.new(@card)
      @hands.change
      expect(@hands.numbers).to match_array(["10","5","5","3","5"])
      expect(@hands.suits).to match_array(["H","D","H","C","S"])

    end
    it "valid?1"do
      @card1 = "H10 D5 H5 C3 S5"
      @hands = Cards.new(@card1)
      @hands.change
      if @hands.valid? == true && @hands.uniqueness? == true
        @hands.check(@hands.numbers,@hands.suits)
        expect(@hands.hand).to eq("スリー・オブ・ア・カインド")
      end
    end

    it "valid?2" do
      @card2 = "H10 D5 H10 C3 S5"
      @hands = Cards.new(@card2)
      @hands.change
      if @hands.valid? == true && @hands.uniqueness? == true
      else
        @hands.error = "入力値が無効です"
        expect(@hands.error).to eq("入力値が無効です")
      end

    end
  end

end
