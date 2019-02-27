Rails.application.routes.draw do
  root to: 'visitors#index'
  get "home/top" => "home#top"
  post "home/judge_hand" => "home#judge_hand"
 mount Base::API => "/"
end
