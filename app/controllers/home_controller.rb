class HomeController < ApplicationController

  def top
    @cards = Cards.new(card: nil, api_card: nil)
  end

  def judge_hand
    card = params[:card]
    @cards = Cards.new(card: card, api_card: nil)
    @cards.judge
    if @cards.error == nil
      flash[:notice] = @cards.hand[:name]
      redirect_to :action => "top"
    else
      flash.now[:notice] = @cards.error
      render :action => "top" ,:status => 400
    end

  end
end
