SimpleDateTextPicker =
  init: ->

ready = ->
  SimpleDateTextPicker.init()
$(document).ready ready
$(document).on 'page:load', ready
