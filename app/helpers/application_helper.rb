module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then "info"
    when :error then "danger"
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

  def glyphicon(name)
    content_tag(:span, "", class: "glyphicon glyphicon-#{name}")
  end

  def fieldset(title, &block)
    legend = content_tag(:legend, title)
    content = capture(&block)
    content_tag(:fieldset, legend + content)
  end

  def local_time(time)
    time.try(:in_time_zone, Time.zone).to_s
  end

  def value_or_empty_marker(value)
    value || "--"
  end

  def scheduled_action_level_or_empty(service, scheduled_action)
    matching_level = service.levels.detect do |level|
      level[:min] == scheduled_action.min_size &&
      level[:max] == scheduled_action.max_size
    end
    matching_level.try(:[], :name) || "Custom"
  end

  def javascript_controller_name
    "#{controller.controller_path.camelize}Controller"
  end
end
