class API < Grape::API
  prefix "api"
  format :json
  mount HomeController_API
end
