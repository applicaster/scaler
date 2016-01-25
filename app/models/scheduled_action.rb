class ScheduledAction
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include AwsAutoscalingHelper

  attribute :service_id, String

  attribute :starts_at, ActiveSupport::TimeWithZone,
    default: proc { Time.current }

  attribute :level, String

  def persisted?
    false
  end

  def autoscaling_group_name
    Settings.services[service_id].autoscaling_group_name
  end

  def self.find_by_autoscaling_group_name(autoscaling_group_name)
    autoscaling_client.describe_scheduled_actions({
      auto_scaling_group_name: autoscaling_group_name
    })[:scheduled_update_group_actions]
  end
end
