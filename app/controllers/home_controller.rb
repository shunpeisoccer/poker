class HomeController < ApplicationController

  def top
    @cards = Cards.new(card: nil,api_card: nil)
  end
  def judge_hand
    card = params[:card]
    @cards = Cards.new(card: card,api_card: nil)
    @cards.judge
    render("home/top")
  end
end
