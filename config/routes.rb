Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :urls, only: [] do
        post "encode"
        get "decode"
      end
    end
  end

  root to: "application#index"
end
