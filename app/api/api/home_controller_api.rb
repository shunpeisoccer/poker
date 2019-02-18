class HomeController_API < Grape::API
  resource "HomeController" do
    params do
      requiers :cards , type: Array
    end
    post '/api', jbuilder:'api/home_api' do
      cards =  params[:cards]
      allhand = []
      cards.each do |card|
        @hands = Cards.new(card)
        @hands.change
        if @hands.valid? == true && @hands.uniqueness? == true
          @hands.check(@hands.numbers,@hands.suits)
          @hands.handnumber = YAKU.find_index(@hands.hand)
          allhand.push(@hands.handnumber)
        else
          @hands = nil
        end
       if @hands.handnumber == allhand.max
         @hands.best = true
       else
         @hands.best = false
       end

    end


  end
end