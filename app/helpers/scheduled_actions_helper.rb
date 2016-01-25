module ScheduledActionsHelper
  def service_levels
    Settings.services[scheduled_action.service_id].levels
  end
end
