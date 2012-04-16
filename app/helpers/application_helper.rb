module ApplicationHelper

  def title
    base_title = "Personal time tracker"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def active_menu?(action, only_controller = true)
    'active' if action == params[:controller] + (only_controller == true ? '' : ('#'+params[:action]))
  end

  def get_tooltip_text time_id
    if time_id >= 60
        time = time_id/60<10 ? '0' + (time_id/60).to_s : (time_id/60).to_s
        time = time + ':'
        time = time + (time_id%60 == 0 ? '00' : (time_id%60).to_s)
    else
        time = '00:' + ( time_id == 0 ? '00' : time_id ).to_s
    end
  end

end
