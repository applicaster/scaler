class Service
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include AwsAutoscalingHelper

  attribute :id, String
  attribute :name, String
  attribute :region, String
  attribute :autoscaling_group_name, String
  attribute :autoscaling_group
  attribute :levels, Array[Level]

  def persisted?
    true
  end

  def scheduled_actions
    ScheduledAction.find_all(
      autoscaling_group_name: autoscaling_group_name,
      region: region,
    )
  end

  def self.all
    asg_by_region = autoscaling_groups_by_region

    services.
      to_a.
      select {|id, attributes| asg_by_region[attributes[:region]][attributes[:autoscaling_group_name]] }.
      map { |id, attributes| Service.find(id) }.
      each { |s| s.autoscaling_group = asg_by_region[s.region][s.autoscaling_group_name] }
  end

  def self.find(id)
    return nil if services[id].blank?
    Service.new(services[id].to_hash.merge(id: id))
  end

  def self.services
    @services ||= Settings.services.to_hash.with_indifferent_access.tap do |services_data|
      validate_services_data(services_data)
    end
  end

  def self.validate_services_data(services_data)
    raise TypeError unless services_data.kind_of?(Hash)
    services_data.each do |id, attributes|
      message = "'#{id}' service is misconfigured"
      fail(ArgumentError, message) unless attributes[:autoscaling_group_name].present?
      fail(ArgumentError, message) unless attributes[:region].present?
      fail(ArgumentError, message) unless attributes[:levels].present?
      fail(ArgumentError, message) unless attributes[:levels].kind_of?(Array)
      attributes[:levels].each do |level|
        fail(ArgumentError, message) unless level[:name].present?
        fail(ArgumentError, message) unless level[:label].present?
        fail(ArgumentError, message) unless level[:min].present?
        fail(ArgumentError, message) unless level[:max].present?
      end
    end
  end

  def self.services=(val)
    @services = val
  end

  def self.autoscaling_groups_by_region
    services.map { |id, attributes| attributes[:region] }.uniq.reduce({}) do |hash, region|
      hash.merge(region => autoscaling_groups_for_region(region))
    end
  end

  def self.autoscaling_groups_for_region(region)
    autoscaling_client(region: region).
      describe_auto_scaling_groups.
      data[:auto_scaling_groups].
      reduce({}) { |hash, group| hash.merge(group.auto_scaling_group_name => group) }
  end
end

