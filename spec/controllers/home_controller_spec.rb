require 'rails_helper'


describe HomeController do
  before:each do
    @card1 = "H10 D5 H5 C3 S5"
    @card2 = "H10 D5 H10 C3 S5"
  end

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
      params[:card] = "H10 D5 H5 C3 S5"
      expect(assigns(:card)).to eq params[:card]

    end
    it "assigns the requessted massage to @hands" do
      @card = "H10 D5 H5 C3 S5"
      @hands = Cards.new(@card)
      @hands.change
      expect(@hands.numbers).to match_array([10,5,5,3,5])
      expect(@hands.suits).to match_array([H,D,H,C,S])

    end
    it "valid?1"do
       @hands = Cards.new(@card1)
       @hands.change
      @hands.valid?
      expect(@hands.hand).to eq("スリー・オブ・ア・カインド")
    end
    it "valid?2"do
      @hands = Cards.new(@card2)
      @hands.change
      @hands.valid?
      except(@hands.error).to eq("入力値が無効です")
    end
  end
end