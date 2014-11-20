NewEvent =
  init: ->
  	$('.tut-1 #tut-right').click @goNextTutStep
  	$('.tut-2 #tut-left').click @goBackTutStep
  	$('.tut-2 #tut-right').click @finishTut
  	$('#event_threshold').change @showNextArrow

  finishTut: ->
  	$('.tut-1, .tut-2').hide()

  showNextArrow: ->
  	$('.tut-1 #tut-right').show()

  goNextTutStep: ->
  	$('.tut-1').hide()
  	$('.tut-2').show()

  goBackTutStep: ->
  	$('.tut-1').show()
  	$('.tut-2').hide()


ready = ->
  NewEvent.init() 
$(document).ready ready
$(document).on 'page:load', ready



