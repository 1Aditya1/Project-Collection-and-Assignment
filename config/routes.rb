Rails.application.routes.draw do
  get 'documents/index'

  get 'documents/new'

  get 'documents/create'

  get 'documents/destroy'

  get 'password_resets/new'

  get 'password_resets/edit'

        get 'sessions/new'

        get 'users/new'

        root             'sessions#home'
        get    'help'    => 'static_pages#help'
        get    'about'   => 'static_pages#about'
        get    'contact' => 'static_pages#contact'
        get    'signup'  => 'users#new'
        get    'login_netid' => 'static_pages#new'
        get    'login'   => 'sessions#new'
        post   'login'   => 'sessions#create'
        delete 'logout'  => 'sessions#destroy'
        get    'resetDB' => 'reset#downloadAndReset'
        resources :users
        resources :projects
        resources :documents
        
        resources :projects do
                member do
                        get :approve, :unapprove
                        patch :toggle
                end
                
                get :legacy
                post :legacy
                get :legacy_add
        end
        resources :password_resets,     only: [:new, :create, :edit, :update]

        get 'add_project'               => 'projects#new'
        get 'approved_projects'         => "projects#approved"
        get 'unapproved_projects'       => "projects#unapproved"
        get 'peer_evaluation'           => "projects#do_peer_evaluation"
        post 'peer_evaluation'          => "projects#submit_peer_evaluation"

        resources :users do
                get :project
                post :upload
                get :download
                get :admin_download
		post :update_project
                get :make_admin
                
        end

        resources :teams
		post 'remove' => 'teams#remove'
		post 'add_user' => 'teams#add_user'

        resources :teams do
                member do
                        get :preference
                end
        end

        resources :relationships, only: [:destroy]
        get 'jointeam' => 'relationships#new'
        post 'jointeam' => 'relationships#create'
        delete 'leaveteam' => 'relationships#destroy'

        resources :preferences, only: [:create]
        get 'assign' => 'assignments#assign'
        get 'viewassign' => 'assignments#view'
        get 'download' => 'assignments#download'

        resources :preassignments
        get 'preassignment' => 'preassignments#show'
        post 'preassignment' => 'preassignments#view'
        get 'preassign' => 'preassignments#new'
        post 'preassign' => 'preassignments#create'

		resources :assignments
		post 'delete' => 'assignments#delete'
		post 'add' => 'assignments#add'


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
