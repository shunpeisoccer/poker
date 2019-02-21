module V1
  class Root < Grape::API
    prefix "api"
    version :v1, using: :path
    format :json
    mount V1::Cards_Api
  end
end

