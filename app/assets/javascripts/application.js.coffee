# = require jquery
# = require jquery_ujs
# = require bootstrap-sprockets
# = require_self
# = require_tree .

class window.App
  @start_page_controller: () ->
    controllerName = $("body").data("controller")
    actionName = $("body").data("action")

    if App[controllerName]
      controller = new App[controllerName]
      if controller[actionName]
        controller[actionName]()
