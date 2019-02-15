class HomeController < ApplicationController

  def top
    @hands = Cards.new(nil)
  end
  def poker
    @card = params[:card]
    @hands = Cards.new(@card)
    @hands.change
    if @hands.valid? == true && @hands.uniqueness? == true
      @hands.check(@hands.numbers,@hands.suits)
      render("home/top")
    else
      @hands.error = "入力値が無効です"
      render("home/top")
    end

  end
end
