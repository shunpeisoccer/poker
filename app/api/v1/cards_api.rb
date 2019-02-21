module V1
  class Cards_Api < Grape::API
    HAND_NAME = ["ハイカード","ワンペア","ツーペア","スリー・オブ・ア・カインド","ストレート","フラッシュ","フルハウス","フォー・オブ・ア・カインド","ストレートフラッシュ"]

    resource "card"  do
      params do
        requires :cards , type: Array
      end
      post"/judge"  do
        cards =  params[:cards]
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
         results
      end
    end
  end
end