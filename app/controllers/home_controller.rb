class HomeController < ApplicationController

  def top
    @hands = Cards.new(nil)
  end
  def poker
    card = params[:card]
    @hands = Cards.new(card)
    @hands.change_card_to_numbers_and_suits
    if @hands.valid? == true && @hands.unique? == true
      @hands.check_hand(@hands.numbers,@hands.suits)
      render("home/top")
    else
      @hands.error = "入力値が無効です"
      render("home/top")
    end

  end
end