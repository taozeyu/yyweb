class NotificationController < ApplicationController

  def index
    if curr_user.nil?
      @messages = []
    else
      if curr_user.notification_logs_num > 0
        NotificationLog.copy_messages(curr_user)
      end
      @messages = NotificationMessage.find(curr_user)
    end
    render :'notification/show', :layout => false
  end
  
  def destroy
    message_ids = params[:message_ids].split(',')
    NotificationMessage.where("user_id = #{curr_user.id} and id in (#{message_ids.join(',')})").destroy_all
    render :text => 'ok'
  end
  
end
