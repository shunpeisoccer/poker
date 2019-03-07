module V1
  class Cards_Api < Grape::API

    resource "card"  do
      params do
        requires :cards , type: Array
      end
      post"/judge"  do
        @cards = Cards.new(card: nil , api_card: params[:cards])
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
        return {"result" => @cards.result}
        end
      end
  end
end