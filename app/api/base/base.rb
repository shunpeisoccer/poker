module Base
  class API < Grape::API
    prefix "api"
    format :json
    request_error = {error: [{msg: "不正なリクエストです。"}]}
    url_error = {error: [{msg: "不正なURLです。"}]}

    rescue_from :all do
      error!(request_error)
    end

    route :any, '*path' do
      error!(url_error)
    end

    mount V1::Root
  end
end