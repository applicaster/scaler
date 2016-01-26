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
    ScheduledAction.find_all_by_autoscaling_group_name(autoscaling_group_name)
  end

  def self.all
    response = autoscaling_client.describe_auto_scaling_groups
    autoscaling_groups = response.data[:auto_scaling_groups].reduce({}) do |hash, group|
      hash.merge(group.auto_scaling_group_name => group)
    end

    Settings.services.
      to_a.
      select {|id, attributes| autoscaling_groups[attributes.autoscaling_group_name] }.
      map { |id, attributes| Service.find(id) }.
      each { |s| s.autoscaling_group = autoscaling_groups[s.autoscaling_group_name] }
  end

  def self.find(id)
    return nil if Settings.services[id].blank?
    Service.new(Settings.services[id].to_hash.merge(id: id))
  end
end

