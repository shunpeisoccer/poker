require 'rails_helper'
describe  "Cards_Api" do

  it "renders the judge template"do
    post"/api/v1/card/judge"
    expect(response.status).to eq 400

  end

  describe "api_judge" do
    before do
      card = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
      @cards = Cards.new(card: nil,api_card: card)
      @cards.api_judge
    end
    it "results" do
      expect(@cards.results).to match_array([{"card"=>"H1 H13 H12 H11 H10","hand"=>"ストレートフラッシュ","best"=>true},{"card"=>"H9 C9 S9 H2 C2","hand"=>"フルハウス","best"=>false},{"card"=>"C13 D12 C11 H8 H7","hand"=>"ハイカード","best"=>false}])
    end
  end
end


