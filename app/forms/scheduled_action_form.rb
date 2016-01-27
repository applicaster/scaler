require "time_with_zone_attribute"
require "associated_validator"

class ScheduledActionForm
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :service, Service
  attribute :scheduled_action, ScheduledAction
  attribute :level_name, String
  attribute :start_time, TimeWithZoneAttribute,
    default: proc { Time.current.change(sec: 0, usec: 0) }

  validates :start_time, presence: true
  validates :level_name, presence: true
  validates :service, presence: true

  validate :start_time_is_in_the_future

  validates :scheduled_action,
    presence: true,
    associated: true

  def save
    scheduled_action.attributes = scheduled_action_attributes
    return false unless valid?
    return false unless scheduled_action.save

    true
  end

  def persisted?
    false
  end

  def model_name
    ScheduledAction.model_name
  end

  def scheduled_action_attributes
    {
      start_time: start_time,
      autoscaling_group_name: service.autoscaling_group_name,
      min_size: level.try(:[], :min),
      max_size: level.try(:[], :max),
    }
  end

  def level
    return nil unless level_name
    @level ||= service.levels.find { |l| l[:name] == level_name }
  end

  private

  def start_time_is_in_the_future
    return if start_time > Time.now
    errors.add(:start_time, "must be in the future")
  end
end
