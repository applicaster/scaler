helpers do
  def error_messages_for(record, options={})
    return "" if record.blank? or record.errors.none?
    options.reverse_merge!(header_message: "The #{record.class.to_s.downcase} could not be saved!")
    error_messages = record.errors.full_messages
    error_items = error_messages.collect { |er| content_tag(:p, er, class: 'text-danger') }.join("\n")
    error_html = content_tag(:strong, options.delete(:header_message))
    error_html << error_items
    content_tag(:div, error_html, class: 'alert alert-danger')
  end

  def groups_for_select
    AWS::AutoScaling.new.groups.map { |l| l.name }
  end

  def local_time(time)
    time.in_time_zone(ENV['SCALER_TZ'])
  end
end
