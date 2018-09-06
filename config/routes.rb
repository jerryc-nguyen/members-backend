Rails.application.routes.draw do

  namespace :api do
    namespace :v1, path: "v1" do

      resources :auth, only: [] do
        collection do
          post :login
        end
      end

      resources :users, only: [:index] do
        collection do
          get :autocomplete
        end
      end

      resources :posts, only: [:index] do
        collection do
        end
      end

    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "api#index"
end
