require 'rails_helper'
describe "Cards_Api" do
  describe "request" do
    context "正常系"
    it 'has a 201 status code' do
      post "/api/v1/card/judge", params: {"cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]}
      expect(response.status).to eq 201
    end

    context '異常系' do
      it '不正url' do
        post "/api/v1/card", params: {"cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]}
        expect(response.status).to eq 500
        expect(response.body).to eq "{\"error\":[{\"msg\":\"不正なURLです。\"}]}"
      end

      it '不正リクエスト' do
        post "/api/v1/card/judge", params: {}
        expect(response.status).to eq 500
        expect(response.body).to eq "{\"error\":[{\"msg\":\"不正なリクエストです。\"}]}"
      end
    end
  end


  describe "#new" do
    it "Cards.new" do
      @cards = Cards.new(card: nil, api_card: ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"])
      expect(@cards.api_card).to match_array(["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"])
    end
  end


  describe "api_judge" do

    before do
      @cards = Cards.new(card: nil, api_card: nil)
    end

    context "正常系" do
      it "results" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
        @cards.api_judge
        @cards.result.each do |hash|
          if hash["msg"] == nil
            if hash["strength"] == @cards.all_hand.max
              hash["best"] = true
              hash.delete("strength")
            else
              hash["best"] = false
              hash.delete("strength")
            end
          end
        end
        results = {"result" => @cards.result}
        expect(results["result"]).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => true}, {"card" => "H9 C9 S9 H2 C2", "hand" => "フルハウス", "best" => false}, {"card" => "C13 D12 C11 H8 H7", "hand" => "ハイカード", "best" => false}])
      end
    end
    context "異常系" do
      it "valid_size" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 "]
        @cards.api_judge
        @cards.result.each do |hash|
          if hash["msg"] == nil
            if hash["strength"] == @cards.all_hand.max
              hash["best"] = true
              hash.delete("strength")
            else
              hash["best"] = false
              hash.delete("strength")
            end
          end
        end
        results = {"result" => @cards.result}
        expect(results["result"]).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => true}, {"card" => "H9 C9 S9 H2 ", "msg" => "5つのカード指定文字を半角スペース区切りで入力してください。(例：\"S1 H3 D9 C13 S11\")"},])
      end
      it "valid_form" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 H67 "]
        @cards.api_judge
        @cards.result.each do |hash|
          if hash["msg"] == nil
            if hash["strength"] == @cards.all_hand.max
              hash["best"] = true
              hash.delete("strength")
            else
              hash["best"] = false
              hash.delete("strength")
            end
          end
        end
        results = {"result" => @cards.result}
        expect(results["result"]).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => true}, {"card" => "H9 C9 S9 H2 H67 ", "msg" => "5番目のカード指定文字が不正です(H67)。"},])
      end
      it "valid_unique" do
        @cards.api_card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 H9 "]
        @cards.api_judge
        @cards.result.each do |hash|
          if hash["msg"] == nil
            if hash["strength"] == @cards.all_hand.max
              hash["best"] = true
              hash.delete("strength")
            else
              hash["best"] = false
              hash.delete("strength")
            end
          end
        end
        results = {"result" => @cards.result}
        expect(results["result"]).to match_array([{"card" => "H1 H13 H12 H11 H10", "hand" => "ストレートフラッシュ", "best" => true}, {"card" => "H9 C9 S9 H2 H9 ", "msg" => "カードが重複しています。"},])
      end
    end
  end
end





