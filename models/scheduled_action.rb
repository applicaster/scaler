class ScheduledAction 
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :name, String
  attribute :group, String
  attribute :desired_capacity, Integer
  attribute :min_size, Integer
  attribute :max_size, Integer
  attribute :start_time, Time

  validates_presence_of :name, :group, :start_time
  validate :action_makes_some_change

  def self.find(name)
    aws_scheduled_action = auto_scaling.scheduled_actions.detect { |a| a.name == name }
    if aws_scheduled_action
      scheduled_action = self.new
      %w{ name desired_capacity start_time}.each do |attr|
        scheduled_action.send("#{attr}=", aws_scheduled_action.send(attr))
      end
      scheduled_action.group = aws_scheduled_action.auto_scaling_group_name
      scheduled_action
    else
      nil
    end
  end

  def self.all
    auto_scaling.scheduled_actions
  end

  def start_time=(time)
    time.is_a?(Time) ? time : time = Time.zone.parse(time)
    super
  end

  def start_time
    time = super
    time ? time.in_time_zone(ENV['SCALER_TZ']) : time
  end

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def destroy
    aws_scheduled_action = auto_scaling.scheduled_actions.detect { |a| a.name == name }
    aws_scheduled_action.delete if aws_scheduled_action
  end

  private

  def persist!
    if auto_scaling.scheduled_actions.filter(group: group)[name].exists?
      auto_scaling.scheduled_actions.filter(group: group)[name].update(attributes_for_api_call)
    else
      auto_scaling.scheduled_actions.create(name, { group: group }.merge(attributes_for_api_call))
    end
  end

  def attributes_for_api_call
    {}.tap do |attributes|
      attributes[:start_time] = start_time
      attributes[:min_size] = min_size if min_size.present?
      attributes[:max_size] = max_size if max_size.present?
      attributes[:desired_capacity] = desired_capacity if desired_capacity.present?
    end
  end

  def action_makes_some_change
    return if min_size.present?
    return if max_size.present?
    return if desired_capacity.present?
    errors.add(:base, "Action is not making any change (min, max or desired)")
  end

  def self.auto_scaling
    AWS::AutoScaling.new
  end

  def auto_scaling
    self.class.auto_scaling
  end
end
