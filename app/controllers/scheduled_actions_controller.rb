class ScheduledActionsController < ApplicationController
  expose(:scheduled_action, attributes: :scheduled_action_params)

  def new
    self.scheduled_action = ScheduledAction.new(scheduled_action_params)
  end

  def starts_at
    super.in_time_zone(Time.zone)
  end

  def scheduled_action_params
    params.require(:scheduled_action).permit(
      :service_id,
    )
  end
end
