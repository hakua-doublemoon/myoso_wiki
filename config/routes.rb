Rails.application.routes.draw do

  #get 'myoso_wiki/home'
  root :to => 'myoso_wiki#home'
  get 'home/home_menu' => 'myoso_wiki#menu'
  get 'home/home_main' => 'myoso_wiki#home_main'

  #get 'myoso_wiki/index'
  get 'index' => 'myoso_wiki#index'
  get 'index/:filename' => 'myoso_wiki#index'

  get 'index/myoso_wiki/menu' => 'myoso_wiki#menu'
  get 'index/myoso_wiki/main/:filename' => 'myoso_wiki#main'

  get 'myoso_wiki/menu'

  #get 'myoso_wiki/main' #filenameなしは未サポート
  get 'myoso_wiki/main/:filename' => 'myoso_wiki#main'

  #get 'myoso_wiki/home_main'

  #get 'myoso_wiki/mw_fileio'

  #get 'myoso_wiki/menu_list'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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