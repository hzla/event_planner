SimpleEventResults =
  init: ->
    $('.choice-header').click @expandColumn

  expandColumn: ->
    
ready = ->
  SimpleEventResults.init()
$(document).ready ready
$(document).on 'page:load', ready
