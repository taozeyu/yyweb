class SettingController < ApplicationController

  def show_personal
    if curr_user.nil?
      redirect_to '/'
      return
    end
    
    render 'setting/personal'
  end
  
  def show_icon
    if curr_user.nil?
      redirect_to '/'
      return
    end
    
    render 'setting/icon'
  end
  
  def update_personal
    if curr_user.nil?
      redirect_to '/'
      return
    end
    birthday = params[:birthday]
    signature = params[:signature]
    
    birthday = nil if birthday.blank?
    birthday = DateTime.parse(birthday).strftime('%Y-%m-%d') unless birthday.nil?
    
    signature = nil if signature.blank?
    
    curr_user.sex = params[:sex]
    curr_user.birthday = birthday
    curr_user.signature = signature
    curr_user.save
    
    redirect_to :back
  end
  
  def upload_icon
    if curr_user.nil?
      render :json => {:code => 403}
      return
    end
    upload = request.raw_post
    name = "userid#{curr_user.id}.jpg"
    file = "public/images/user_icon/#{name}"
    File.open(file, "wb") do |f|
      f.write(upload)
    end
    curr_user.icon = name
    curr_user.save
    
    render :json => {:code => 200}
  end
  
end
