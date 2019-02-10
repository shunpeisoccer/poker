class HomeController < ApplicationController
   include CheckModule
  def top
  end
  def poker
    @card = params[:card]
    tranp = @card.split
    suits = []
    numbers = []

    tranp.each do |t|
      suits.push t[0]
      numbers.push t[1]
    end
    
    @hand = @hand.check(numbers,suits)
  end
end
