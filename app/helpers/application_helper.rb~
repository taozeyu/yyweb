#!/bin/env ruby
# encoding: utf-8

module ApplicationHelper
  
  def time_to_now (time)
    now = Time.now
    if now - 30.seconds < time
      return "几秒"
    elsif now - 1.minutes < time
      return "几十秒"
    elsif now - 1.hours < time
      return "#{(now.to_i - time.to_i)/(1.minutes.to_i)}分钟"
    elsif now - 1.days < time
      return "#{(now.to_i - time.to_i)/(1.hours.to_i)}小时"
    elsif now - 1.months < time
      return "#{(now.to_i - time.to_i)/(1.days.to_i)}天"
    elsif now - 1.years < time
      return "#{(now.to_i - time.to_i)/(1.months.to_i)}月"
    else
      return "#{(now.to_i - time.to_i)/(1.years.to_i)}年"
    end
  end
  
  def formate_date(time)
    DateTime.parse(time.to_s).strftime('%Y-%m-%d').to_s
  end
  
  def limit_length(str, length)
    if str.length <= length
      return str
    else
      return "#{str[0..(length-3)]}..."
    end
  end
  
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
  
  def node_path(node)
    "/node/#{node.id}/#{node.path_name}"
  end
  
end
