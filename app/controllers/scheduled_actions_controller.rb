class ScheduledActionsController < ApplicationController
  expose(:service) { Service.find(params[:service_id]) }

  expose(:scheduled_action)
  expose(:scheduled_action_form, attributes: :scheduled_action_params)

  before_action :set_scheduled_action_form_dependencies, only: [:new, :create]

  def new
  end

  def create
    if scheduled_action_form.save
      redirect_to services_url, notice: "Scheduled action created"
    else
      render :new
    end
  end

  def destroy
    if ScheduledAction.destroy(params[:id])
      flash[:notice] = "Deleted scheduled action #{params[:id]}"
      redirect_to services_url
    else
      flash[:error] = "Could not delete scheduled action #{params[:id]}"
      redirect_to services_url
    end
  end

  def scheduled_action_params
    params.require(:scheduled_action).permit(
      :start_time,
      :level_name,
    )
  end

  def set_scheduled_action_form_dependencies
    scheduled_action_form.attributes = {
      service: service,
      scheduled_action: scheduled_action,
    }
  end
end
