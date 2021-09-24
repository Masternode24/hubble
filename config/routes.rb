Rails.application.routes.draw do
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create', as: 'login_submit'
  get 'login/verify', to: 'sessions#verify', as: 'login_verify'
  post 'login/verify', to: 'sessions#verify'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/password/forgot', to: 'sessions#forgot_password', as: 'forgot_password'
  post '/password/reset', to: 'sessions#reset_password', as: 'reset_password'
  get '/password/recover', to: 'sessions#recover_password', as: 'recover_password'

  resources :users, only: %i[new create update] do
    collection do
      get :welcome
      get :confirm
      get :confirmed
      get :settings
    end
  end

  root to: 'home#index'
  get '/disclaimer', to: 'home#disclaimer', as: :disclaimer

  # API
  namespace :api do
    namespace :v1 do
      namespace :prime do
        namespace :eth2_staking do
          root to: 'home#show'

          resources :positions, only: %i[index show]
          resources :validators, only: %i[index show]
        end
      end

      match '*path', to: 'base#invalid_route', via: :all
    end
  end

  # PRIME
  namespace :prime do
    root to: 'home#index'

    resources :accounts, only: %i[index create update destroy]
    resources :api_keys, only: %i[create destroy]

    get :portfolio, to: 'portfolios#index'
    get :events, to: 'events#index'
    get :profile, to: 'profile#show'
    post 'profile/verify_mfa'
    post 'profile/disable_mfa'

    get :validators, to: 'validators#index'
    get :rewards, to: 'rewards#index'
    get :login, to: 'sessions#new'
    get :contact, to: 'contact#index'
    post :contact, to: 'contact#create', as: 'contact_submit'

    namespace :eth2_staking do
      get '/', to: 'home#index'
      get 'docs', to: 'home#docs'

      resources :staking_positions, only: [:show] do
        get :funding, on: :member
      end
    end

    match 'proxy/:network_id/chains/:chain_id/(*path)', to: 'proxy#index', via: :all, as: :rpc_proxy

    namespace :admin do
      root to: 'main#index'
      resources :networks do
        resources :chains, constraints: { id: /[^\/]+/ }, except: %i[index edit]
      end

      namespace :analytics do
        resources :networks, only: %i[index show]
      end

      namespace :eth2_staking do
        root to: 'home#index'

        resources :customers, only: %i[index show]
        resources :validators, only: %i[index show]
        resources :staking_positions, only: %i[index]
      end
    end
  end

  # HUBBLE
  concern :cosmoslike do
    resources :chains, format: false, constraints: { id: /[^\/]+/ }, only: %i[show] do
      get '/dashboard' => 'dashboard#index', as: 'dashboard'

      resource :faucet, only: %i[show] do
        resources :faucet_transactions, as: 'transactions', path: 'transactions', only: %i[create]
      end

      member do
        get :search
        get :halted
        get :prestart
        post :broadcast
      end

      resources :events, only: %i[index show]

      resources :validators, only: %i[show] do
        resources :subscriptions, only: %i[index create], controller: '/util/subscriptions'
      end

      resources :accounts, only: %i[show]

      resources :blocks, only: %i[show] do
        resources :transactions, only: %i[show]
      end
      resources :transactions, only: %i[show]

      resources :logs, only: %i[index], controller: '/util/logs'

      namespace :governance do
        root to: 'main#index'
        resources :proposals, only: %i[show]
      end

      resources :watches, as: 'watches', only: %i[create]
    end
  end

  get '/chains/*path', to: redirect('/cosmos/chains/%{path}')

  namespace :cosmos, network: 'cosmos' do
    concerns :cosmoslike
    resources :chains, format: false, constraints: { id: /[^\/]+/ }, only: %i[show] do
      resources :transactions, only: %i[index show]
    end
  end

  namespace :crypto, network: 'crypto' do
    concerns :cosmoslike
    resources :chains, format: false, constraints: { id: /[^\/]+/ }, only: %i[show] do
      resources :transactions, only: %i[index show]
    end
  end

  namespace :terra, network: 'terra' do
    concerns :cosmoslike
    resources :chains, format: false, constraints: { id: /[^\/]+/ }, only: %i[show] do
      resources :transactions, only: %i[index show]
    end
  end

  namespace :iris, network: 'iris' do concerns :cosmoslike end
  namespace :kava, network: 'kava' do concerns :cosmoslike end
  namespace :emoney, network: 'emoney' do concerns :cosmoslike end
  namespace :persistence, network: 'persistence' do concerns :cosmoslike end

  namespace :near, network: 'near' do
    resources :chains, format: false, only: :show do
      get :search, on: :member
      get '/dashboard' => 'dashboard#index', as: 'dashboard'

      resources :validators, only: :show, constraints: { id: /[^\/]+/ } do
        resources :subscriptions, only: %i[index create], controller: '/util/subscriptions'
      end
      resources :blocks, only: :show, constraints: { id: /[^\/]+/ } do
        resources :transactions, only: :show, constraints: { id: /[^\/]+/ }
      end
      resources :events, only: %i[index show]
      resources :accounts, only: :show, constraints: { id: /[^\/]+/ }
    end

    root to: 'chains#show'
  end

  namespace :avalanche, network: 'avalanche' do
    resources :chains, constraints: { id: /[^\/]+/ }, only: :show do
      member do
        get :show
        get :search
      end
      get '/dashboard' => 'dashboard#index', as: 'dashboard'

      resources :validators, only: :show, constraints: { id: /[^\/]+/ } do
        resources :subscriptions, only: %i[index create], controller: '/util/subscriptions'
      end
      resources :accounts, only: :show
      resources :transactions, only: %i[index show]
      resources :events, only: %i[index show]
    end
    root to: 'chains#show'
  end

  namespace :skale, network: 'skale' do
    resources :chains, constraints: { id: /[^\/]+/ } do
      member do
        get :show
        get :search
      end
      get '/dashboard' => 'dashboard#index', as: 'dashboard'
      # this is required as Skale doesn't have blocks as such
      # and our daily reports require a block endpoint
      get '/block' => 'chains#show'

      resources :validators, only: :show do
        resources :subscriptions, only: %i[index create], controller: '/util/subscriptions'
      end
      resources :nodes, only: :show, constraints: { id: /[^\/]+/ }
      resources :accounts, only: %i[index show]
      resources :events, only: %i[index show]
    end
    root to: 'chains#show'
  end

  namespace :mina, network: 'mina' do
    resources :chains do
      member do
        get :show
        get :search
      end

      resources :blocks, only: :show
      resources :accounts, only: :show
      resources :validators, only: :show
      resources :transactions, only: %i[index show]
      resources :transaction_broadcasts, only: :create
      resources :account_balances, only: :show
    end
  end

  namespace :oasis, network: 'oasis' do
    resources :chains, only: %i[show] do
      get '/dashboard' => 'dashboard#index', as: 'dashboard'

      member do
        get :search
      end

      resources :blocks, only: %i[show] do
        resources :transactions, only: %i[show]
      end
      resources :validators, only: %i[show] do
        resources :subscriptions, only: %i[index create], controller: '/util/subscriptions'
      end

      resources :accounts, only: %i[show]
      resources :reports, only: %i[new create show]
    end
  end

  namespace :livepeer, network: 'livepeer' do
    resources :chains, format: false, constraints: { id: /[^\/]+/ }, only: %i[show] do
      get '/dashboard' => 'dashboard#index', as: 'dashboard'
      get :search, on: :member

      resources :events, only: %i[index show]

      resources :rounds, only: %i[show], param: :number
      resources :orchestrators, only: %i[show], param: :address

      resource :orchestrator_pool_report, only: %i[new show]

      resources :delegator_lists do
        resource :report, only: %i[new show], controller: :delegator_list_reports
        resources :subscriptions, only: %i[index create]
        resources :events, only: %i[index], controller: :delegator_list_events
      end
    end
  end

  namespace :tezos, network: 'tezos', chain_id: 'mainnet' do
    get '/dashboard' => 'dashboard#index', as: 'dashboard'
    resources :searches, only: :create
    resources :bakers, only: :show do
      resources :subscriptions, only: %i[index create]
    end
    resources :cycles, only: :show do
      resources :baker_events, only: :index
    end
    namespace :governance, only: :index do
      root to: 'main#index'
      resources :proposals, only: :show
    end
    get '/charts/baker_history/:baker_id', to: 'charts#baker_history'
    root to: 'cycles#show'
  end

  namespace :polkadot, network: 'polkadot' do
    resources :chains, format: false, constraints: { id: /[^\/]+/ }, only: :show do
      get :search, on: :member
      get '/dashboard' => 'dashboard#index', as: 'dashboard'

      resources :blocks, only: :show do
        resources :transactions
      end
      resources :accounts, only: :show
      resources :validators, only: :show do
        resources :subscriptions, only: %i[index create], controller: '/util/subscriptions'
      end
    end
  end

  namespace :celo, network: 'celo' do
    resources :chains, format: false, constraints: { id: /[^\/]+/ }, only: :show do
      get :search, on: :member
      get '/dashboard' => 'dashboard#index', as: 'dashboard'

      resources :validator_groups, only: :show
      resources :validators, only: :show do
        resources :subscriptions, only: %i[index create], controller: '/util/subscriptions'
      end
      resources :blocks, only: :show do
        resources :transactions, only: :show do
          resources :operations, only: :show
        end
      end
      resources :accounts, only: :show
      namespace :governance, only: :index do
        root to: 'main#index'
      end
      resources :events, only: :index
    end
  end

  namespace :telegram do
    resource :account, only: %i[show create destroy]
    post '/webhooks/:token', to: 'webhooks#create'
  end

  # ADMIN
  namespace :admin do
    root to: 'main#index'

    resources :sessions, only: %i[new create]
    get '/logout' => 'sessions#destroy', as: 'logout'

    resources :administrators do
      collection do
        get :setup
        post :setup
      end
    end

    resources :users do
      member do
        get :masq
        patch :toggle_prime
        match :prime_eth_staking, via: %i[get put]
      end
      resources :alert_subscriptions, only: %i[destroy]
    end

    concern :cosmoslike do
      resources :chains, format: false, constraints: { id: /[^\/]+/ } do
        resource :faucet, only: %i[show update destroy]
        resources :faucets, only: %i[create]

        resources :validator_events, only: %i[index]

        member do
          post :move_up
          post :move_down
        end
      end
    end

    namespace :cosmos do concerns :cosmoslike end
    namespace :terra do concerns :cosmoslike end
    namespace :iris do concerns :cosmoslike end
    namespace :kava do concerns :cosmoslike end
    namespace :emoney do concerns :cosmoslike end
    namespace :crypto do concerns :cosmoslike end
    namespace :persistence do concerns :cosmoslike end

    namespace :oasis do
      resources :chains, format: false, constraints: { id: /[^\/]+/ } do
        member do
          post :move_up
          post :move_down
        end
      end
    end

    namespace :livepeer do
      resources :chains, format: false, constraints: { id: /[^\/]+/ }, except: %i[index edit] do
        member do
          post :move_up
          post :move_down
        end
      end
    end

    namespace :tezos do
      resources :chains, except: [:index] do
        member do
          post :move_up
          post :move_down
        end
      end
    end

    namespace :near do
      resources :chains, except: [:index]
    end

    namespace :polkadot do
      resources :chains, except: [:index]
    end

    namespace :mina do
      resources :chains, except: [:index]
    end

    namespace :celo do
      resources :chains, except: [:index]
    end

    namespace :avalanche do
      resources :chains, except: [:index]
    end

    namespace :skale do
      resources :chains, except: [:index]
    end

    namespace :common do
      resources :validator_events, only: %i[destroy]
    end
  end

  mount LetterOpenerWeb::Engine, at: '/_mail' if Rails.env.development?
  health_check_routes
  match '*path', to: 'home#catch_404', via: :all
end
