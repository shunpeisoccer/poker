class HomeController < ApplicationController

  def top
    @hands = Cards.new(nil)
  end
  def poker
    card = params[:card]
    @hands = Cards.new(card)
    @hands.change_card_to_numbers_and_suits
    if @hands.valid_size != true
      @hand = nil
    else
      if @hands.valid_form == true
        @hand = nil
      else
        if@hands.valid_unique != true
          @hand = nil
        else
          @hands.check_hand
        end
      end
    end
    render("home/top")
  end
end