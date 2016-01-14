module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then "info"
    when :error then "error"
    when :alert then "warning"
    end
  end

  def top_navbar_link(label, options)
    active = options.delete(:active) || [[options[:controller]]]
    active_link_to(
      label,
      url_for(options),
      active: active, wrap_tag: :li,
    )
  end
end
