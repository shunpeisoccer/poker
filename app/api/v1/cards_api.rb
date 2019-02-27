module V1
  class Cards_Api < Grape::API

    resource "card"  do
      params do
        requires :cards , type: Array
      end
      post"/judge"  do
        @cards = Cards.new(card: nil , api_card: params[:cards])
        @cards.api_judge
      end
    end
  end
end