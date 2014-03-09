module SettingHelper

  def format_date(date)
    DateTime.parse(date.to_s).strftime('%Y-%m-%d').to_s
  end
  
end
