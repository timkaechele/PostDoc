Rails.application.routes.draw do
  root 'mailboxes#index'
  resources :mailboxes do
    member do
      get 'details', to: 'mailboxes#details'
      post 'mark_all_as_read', to: 'mailboxes#mark_all_as_read'
      post 'clear_mailbox', to: 'mailboxes#clear_mailbox'
    end
  end
  resources :emails, only: [:index, :show] do
    member do
      get '/preview', to: 'emails#body_preview'
    end
  end

  scope :v3 do
    post '/mail/send', to: 'api/emails#create'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
