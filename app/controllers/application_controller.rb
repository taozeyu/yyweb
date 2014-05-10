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
  
  def handle_user_input(content)
    content = CGI::escapeHTML(content)
    content = find_user_in_string(content) do |name ,user|
      yield name, user
    end
    content = find_url_in_string(content)
    return content
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
  
  private
  
  def handle_user_name_notify(user_name)
    "<a class='user-info' href='#'>@#{user_name}</a>&nbsp"
  end
  
  def find_user_in_string(str)
    users = {}
    str = str.gsub(/@\S+ /) do |user_name|
      user_name = user_name[1..(user_name.length - 2)]
      users[user_name.downcase] = user_name
      handle_user_name_notify(user_name)
    end
    names = []
    users.each do |name, value|
      names << "'#{name}'"
    end
    return str if names.empty?
    
    User.where("lower(name) in (#{names.join(', ')})").each do |user|
      yield(user.name, user)
    end
    return str
  end
  
  def find_url_in_string(str)
    regx = /(http|https|ftp):\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/\?%&=]*)?/
    return str.gsub(regx) do |url|
      "<a href='#{url}' rel='nofollow'>#{url}</a>"
    end
  end
  
end
