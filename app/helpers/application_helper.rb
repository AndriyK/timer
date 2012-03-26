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

end
