require 'rails_helper'


describe HomeController, type: :controller do


  describe "GET #top" do
    let(:cards) {Cards.new}
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
      @cards = Cards.new(card: nil, api_card: nil)
      @params = "H1 H2 H3 H4 H5"
    end
    it "returns a 200 request" do
      post :judge_hand, params: {card: "H1 H2 H3 H4 H5" }
      expect(response).to have_http_status "200"
    end
    context "正常系" do
      it "judge" do
        @cards.card = "H10 D5 H5 C3 S5"
        @cards.judge
        expect(@cards.hand[:name]).to eq("スリー・オブ・ア・カインド")
      end
    end

    context "異常系" do
      context "ユーザが不正なデータを登録してきた場合" do
        context "重複したデータを登録してきた場合" do
          it "valid_unique" do
            @cards.card ="H1 H1 D3 D4 H5"
            @cards.judge
            expect(@cards.error).to eq("カードが重複しています。")
          end
        end
        context "５つのカードを登録していない場合" do
          it "valid_size" do
            @cards.card ="H1 H2 D3 D4 "
            @cards.judge
            expect(@cards.error).to eq('5つのカード指定文字を半角スペース区切りで入力してください。(例："S1 H3 D9 C13 S11")')
          end
        end
        context "不正文字が含まれている場合" do
          it "valid_form" do
            @cards.card ="H1 H2 D3 D42 H5"
            @cards.judge
            expect(@cards.error).to eq("4番目のカード指定文字が不正です(D42)\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。")
          end
        end

      end
    end

  end
end
