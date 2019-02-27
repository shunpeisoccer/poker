require 'rails_helper'


describe HomeController do


  describe "GET #top" do
    it "top画面の表示 " do
      #get :top
      expect(assigns(:hands)).to eq nil

    end

  end
  describe "POST #poker" do
    before do
      card = "H10 D5 H5 C3 S5"
      @cards = Cards.new(card: card, api_card: nil)
      @cards.judge
    end
    it "judge" do
      expect(@cards.hand).to eq("スリー・オブ・ア・カインド")
    end

  end

end
