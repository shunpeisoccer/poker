Rails.application.routes.draw do
  root to: 'visitors#index'
  get "home/top" => "home#top"
  post "home/poker" => "home#poker"
 mount Base::API => "/"
end
