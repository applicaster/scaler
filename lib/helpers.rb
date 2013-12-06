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

  def checkbox_checked?(object,method,value)
    object.send(method).include?(value)
  end

  def ec2_instances_for_select
    ['t1.micro','m1.small','m1.medium','m1.large','c1.medium','c1.xlarge']
  end

  def ec2_images_for_select
    EC2.images.with_owner('self').map {|i| [i.name,i.id]}
  end

  def ec2_key_pairs_for_select
    EC2.key_pairs.map {|k| k.name}
  end

  def launch_configurations_for_select
    AS.launch_configurations.map { |l| l.name }
  end

  def groups_for_select
    AS.groups.map { |l| l.name }
  end

  def local_time(time)
    time.in_time_zone(ENV['SCALER_TZ'])
  end

  def image_name(launch_configuration)
    image = launch_configuration.image
    image.exists? ? image.name : "N/A" 
  end

end
