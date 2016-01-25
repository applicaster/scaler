class Service
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include AwsAutoscalingHelper

  attribute :id, String
  attribute :name, String
  attribute :autoscaling_group_name, String
  attribute :autoscaling_group
  attribute :levels, Array

  def persisted?
    true
  end

  def scheduled_actions
    ScheduledAction.find_by_autoscaling_group_name(autoscaling_group_name)
  end

  def self.all
    response = autoscaling_client.describe_auto_scaling_groups
    autoscaling_groups = response.data[:auto_scaling_groups].reduce({}) do |hash, group|
      hash.merge(group.auto_scaling_group_name => group)
    end

    Settings.services.
      to_a.
      select {|id, attributes| autoscaling_groups[attributes.autoscaling_group_name] }.
      map do |id, attributes|
        Service.new(attributes.to_hash.merge({
          id: id,
          autoscaling_group: autoscaling_groups[attributes.autoscaling_group_name],
        }))
      end
  end
end

