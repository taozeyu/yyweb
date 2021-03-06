#!/bin/env ruby
# encoding: utf-8

class UserController < ApplicationController

  def login_page
    render :'user/login', :layout => false
  end
  
  def register_page
    render :'user/register', :layout => false
  end
  
  def login
    login_info = params[:login_info]
    password = params[:password]
    
    if login_info.blank?
      @error_msg = "用户名/Email不可以为空。"
      render :'user/login', :layout => false
      return
    elsif password.blank?
      @error_msg = "密码可以为空。"
      render :'user/login', :layout => false
      return
    end
    
    if User::RexEmail =~ login_info
      user = User.find_by_email(login_info)
    else
      user = User.find_by_name(login_info)
    end
    if user.nil?
      @error_msg = "帐号不存在。"
    else
      if user.password_equals?(password)
        handle_login(user)
        render :text => "refresh"
        if params[:auto_login]!="none"
          value = {
            :user_id => user.id,
            :password_store => user.password_store
          }
          cookies[:atmlogin] = {
            :value => value.to_json,
            :expires => params[:auto_login].to_i.days.from_now,
#           :domain => YYWeb::Application.config.web_name_for_cookies
          }
        end
        return;
      else
        @error_msg = "密码错误。"
      end
    end
    render :'user/login', :layout => false
  end
  
  def logout
    session[:user_id] = nil
    cookies.delete :atmlogind
    redirect_to :back
  end
  
  def register
    user_name = params[:user_name]
    email = params[:email]
    password = params[:password]
    password_confirm = params[:password_confirm]
    
    password_error_msg = check_password(password, password_confirm)
    
    if password_error_msg.nil?
      user = User.new
      user.name = user_name
      user.email = email
      user.password = password
      user.register_at = Time.now
      user.last_login_at = Time.now
      user.schedule = User::Unchecked
      user.group = User::Normal
      
      if user.save
        handle_login(user)
        render :text => "refresh"
      else
        @error_code = user.errors
        puts @error_code
        render :'user/register', :layout => false
      end
    else
      @error_code = { :password => password_error_msg }
      render :'user/register', :layout => false
    end
  end
  
  private
  
  def handle_login(user)
    session[:user_id] = user.id
  end
  
  def check_password(password, password_confirm)
    if password.blank? || password_confirm.blank?
      return "必须两次输入密码"
    elsif password != password_confirm
      return "两次密码不一样"
    elsif password.length < User::PasswordLengthMin || password.length > User::PasswordLengthMax
      return "密码长度必须在#{User::PasswordLengthMin}～#{User::PasswordLengthMax}之间"
    else
      return nil
    end
  end
end
