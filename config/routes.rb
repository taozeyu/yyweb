YYWeb::Application.routes.draw do
  
  resources :post
  resources :comment
  
  resources :paragraph do
    get :single, :on => :member
  end
  
  resources :comment_praise
  
  resources :post_praise
  resources :post_attention

  resources :translated_text
  resources :translated_text_vote
  
  resources :notification
  
  get 'user/loginpage' => 'user#login_page'
  get 'user/registerpage' => 'user#register_page'
  
  post 'user/login' => 'user#login'
  post 'user/register' => 'user#register'
  get 'user/logout' => 'user#logout'
  
  get 'setting/personal' => 'setting#show_personal'
  get 'setting/icon' => 'setting#show_icon'
  
  post 'setting/personal' => 'setting#update_personal'
  post 'setting/upload_icon' => 'setting#upload_icon'
  
  get 'node/:id(/page/:page)(/:path_name)' => 'node#show',
      :as => 'post_list',
      :constraints => {:id => /\d+/, :page => /\d+/ }
  root :to => 'root#show'
  
  get 'util/redirect' => 'util#handle_redirect'
  
end
