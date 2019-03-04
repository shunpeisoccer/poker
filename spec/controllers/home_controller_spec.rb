require 'rails_helper'


describe HomeController, type: :controller do


  describe "GET #top" do
    let(:cards){Cards.new}
    it "top画面の表示 " do
      get :top
      #expect(assigns(:hands)).to eq nil
      expect(response.status).to eq 200
    end
    it 'assigns the requested card to @card' do
      get :top
      expect(assigns :cards).to_not be_nil
    end
    it 'renders the :top template' do
      get :top
      expect(response).to render_template :top
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
