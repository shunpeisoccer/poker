module V1
  class Root < Grape::API
    prefix "api"
    version :v1
    format :json
    resource "card"  do
      params do
      requires :cards , type: Array
      end
      post "/judge/:card"  do
        cards =  params[:cards]
        allhand = []
        results = []
        cards.each do |card|
          @hands = Cards.new(card)
          @hands.change_card_to_numbers_and_suits
          if @hands.valid? == true && @hands.uniqueness? == true
            @hands.check_hand(@hands.numbers,@hands.suits)
            @hands.handnumber = YAKU.find_index(@hands.hand)
            allhand.push(@hands.handnumber)
          else
            @hands = nil
          end
        end
        cards.each do |card|
          @hands = Cards.new(card)
          @hands.change_card_to_numbers_and_suits
          if @hands.valid? == true && @hands.uniqueness? == true
            @hands.check_hand(@hands.numbers,@hands.suits)
            @hands.handnumber = Hand_name.find_index(@hands.hand)
          else
            @hands = nil
          end
          if @hands.handnumber == allhand.max
            @hands.best = true
          else
            @hands.best = false
          end
          result = {"card"=>"#{@hands.card}","hand"=>"#{@hands.hand}","best"=>"#{@hands.best}"}
          results.push(result)
        end
        json.result results
      end
    end
  end
end

