Rails.application.routes.draw do
  get 'credit_cards/index'

  get 'credit_cards/show'

  get 'credit_cards/new'

  get 'credit_cards/update'

  get 'credit_cards/charge'

  get 'users/new' => 'users#new'

  get 'users/index' => 'users#index'

  get 'users/:userId' => 'users#show'

  get 'users/:userId/charge' => 'users#charge'

  #API Routes
  scope '/api' do
    scope '/v1' do
      scope '/users' do
        post '/' => 'api/users#new'
        get '/' => 'api/users#index'

        scope '/:userId' do
          get '/' => 'api/users#show'
          put '/' => 'api/users#update'
          put '/charge' => 'api/users#charge'
        end
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
