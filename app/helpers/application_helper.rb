module ApplicationHelper
  def format_datetime(time)
    return "" unless time

    time.strftime("%Y-%m-%d %H:%M")
  end
end
