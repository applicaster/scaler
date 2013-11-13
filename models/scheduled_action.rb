class ScheduledAction 
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :name, String
  attribute :group, String
  attribute :desired_capacity, Integer
  attribute :start_time, Time

  validates_presence_of :name, :group, :desired_capacity, :start_time

  def self.find(name)
    aws_scheduled_action = AS.scheduled_actions[name]
    if aws_scheduled_action.exists?
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
    AS.scheduled_actions
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
    AS.scheduled_actions[name].delete
  end

  private

  def persist!
    if AS.scheduled_actions[name].exists?
      AS.scheduled_actions[name].update(desired_capacity: desired_capacity, start_time: start_time)
    else
      AS.scheduled_actions.create(name, group: group, desired_capacity: desired_capacity, start_time: start_time)
    end
  end

end
