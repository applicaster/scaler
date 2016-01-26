#= require moment
#= require bootstrap-datetimepicker

class App.ScheduledActionsController
  new: () ->
    minDate = new Date()
    minDate.setSeconds(0)
    minDate.setMilliseconds(0)

    $('#scheduled_action_start_time').datetimepicker({
      format: "YYYY-MM-DD HH:mm"
      minDate: minDate
      useCurrent: false
      extraFormats: [
        "YYYY-MM-DD HH:mm::ss ZZ"
      ]
    })

  create: () ->
    @new()
