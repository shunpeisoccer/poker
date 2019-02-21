require 'rails_helper'
describe  "Cards_Api" do
  HAND_NAME = ["ハイカード","ワンペア","ツーペア","スリー・オブ・ア・カインド","ストレート","フラッシュ","フルハウス","フォー・オブ・ア・カインド","ストレートフラッシュ"]

  it "renders the judge template"do
    post"/api/v1/card/judge"
    expect(response.status).to eq 400

  end
=begin
  it "body_json" do
    body = JSON.parse(response.body)
    expect(body).to be_an_instance_of Array
  end
=end
  it "results" do
    cards = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
    all_hand = []
    results = []
    cards.each do |card|
      @hands = Cards.new(card)
      @hands.change_card_to_numbers_and_suits
      if @hands.valid_size == true && @hands.valid_form != true && @hands.valid_unique == true
        @hands.judge_hand
        @hand_number = HAND_NAME.find_index(@hands.hand)
        all_hand.push(@hand_number)
      else
        @hand = nil
      end
    end
    cards.each do |card|
      @hands = Cards.new(card)
      @hands.change_card_to_numbers_and_suits
      if @hands.valid_size == true && @hands.valid_form != true && @hands.valid_unique == true
        @hands.judge_hand
        @hand_number = HAND_NAME.find_index(@hands.hand)
      else
        @hand = nil
      end
      if @hand_number == all_hand.max
        @best = true
      else
        @best = false
      end
      result = {"card"=>@hands.cards,"hand"=>@hands.hand,"best"=>@best}
      results.push(result)
    end
    expect(results).to match_array([{"card"=>"H1 H13 H12 H11 H10","hand"=>"ストレートフラッシュ","best"=>true},{"card"=>"H9 C9 S9 H2 C2","hand"=>"フルハウス","best"=>false},{"card"=>"C13 D12 C11 H8 H7","hand"=>"ハイカード","best"=>false}])

  end
end