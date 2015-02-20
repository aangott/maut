module ApplicationHelper

  def fa(icon_name, extra_classes)
    "<i class='fa fa-#{icon_name} #{extra_classes}'></i>".html_safe
  end

end
