class ScheduledAction
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include AwsAutoscalingHelper


  attribute :autoscaling_group_name, String
  attribute :desired_capacity, Integer
  attribute :min_size, Integer
  attribute :max_size, Integer
  attribute :scheduled_action_name, String
  attribute :start_time, ActiveSupport::TimeWithZone

  validates :autoscaling_group_name, presence: true
  validates :min_size, presence: true
  validates :max_size, presence: true
  validates :start_time, presence: true

  def self.find_all_by_autoscaling_group_name(autoscaling_group_name)
    autoscaling_client.
      describe_scheduled_actions(auto_scaling_group_name: autoscaling_group_name).
      send(:[], :scheduled_update_group_actions).
      map { |action| self.new(action) }
  end

  def persisted?
    scheduled_action_name.present?
  end

  def save
    return false unless valid?

    scheduled_action_name_or_new.tap do |name|
      resp = autoscaling_client.put_scheduled_update_group_action({
        auto_scaling_group_name: autoscaling_group_name,
        scheduled_action_name: name,
        start_time: start_time,
        min_size: min_size,
        max_size: max_size,
      })
      self.scheduled_action_name ||= name
    end
    true
  end

  private

  def scheduled_action_name_or_new
    scheduled_action_name || generate_scheduled_action_name
  end

  def generate_scheduled_action_name
    [
      autoscaling_group_name,
      Time.now.utc.strftime("%Y%m%d%H%M"),
      rand(1000),
    ].join("-")
  end
end
