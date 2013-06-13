Quantize::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
    get "register", :to => "devise/registrations#new"
  end
  resources :users do
    resources :projects do
      resources :intervals
      resources :invoices
    end
  end
  match "/home" => "users#home"
  match "/home/*other" => redirect("/home")
  match "/actions" => "projects#actions"
  match "/email" => "projects#send_mail"
  match "/mail/success" => "projects#mail_callback"
  match "/invoice/actions" => "invoices#actions"
  #match "/invoice-preview" => "projects#invoice_preview"
  root :to => "pages#index"

end
