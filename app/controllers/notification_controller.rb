class NotificationController < ApplicationController

  def index
    if curr_user.nil?
      @messages = []
      @logs = []
    else
      @messages = NotificationMessage.find(curr_user)
      @logs = []
    end
    render :'notification/show', :layout => false
  end
  
  def destroy
    message_ids = params[:message_ids].split(',')
    NotificationMessage.where("user_id = #{curr_user.id} and id in (#{message_ids.join(',')})").destroy_all
    render :text => 'ok'
  end
  
end
