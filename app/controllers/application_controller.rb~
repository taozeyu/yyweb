class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :auto_login
  
  def curr_user
    return @user if @load_user
    @load_user = true
    user_id = session[:user_id]
    if user_id.nil?
      @user = nil
    else
      @user = User.find_by_id(user_id)
      if @user.nil?
        # means session get some throuble. maybe the programing was updated.
        cookies.delete :atmlogind
      end
    end
    return @user
  end
  
  def can_post?
    (not curr_user.nil?) and curr_user.can_post?
  end
  
  def can_reply?(post)
    (not curr_user.nil?) and curr_user.can_post? and post.can_reply?
  end
  
  def ban?
    curr_user.nil? or curr_user.ban?
  end
  
  def auto_login
    return if session[:has_check_login]
    session[:has_check_login] = true
    
    return if cookies[:atmlogin].nil?
    
    value = JSON.parse(cookies[:atmlogin])
    
    begin
      user_id = value['user_id']
      password_store = value['password_store']
      
      throw :error_cookies if user_id.blank? or password_store.blank?
      
      user = User.find_by_id(user_id)
      throw :error_cookies  if user.nil?
      throw :error_cookies if user.password_store != password_store
      
      session[:user_id] = user.id
      user.last_login_at = Time.now
      user.save
      
      @user = user
      @load_user = true
      
    rescue Exception => e
      cookies.delete :atmlogind
    end
  end
  
end
