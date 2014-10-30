Dashboard =
  init: ->
    $('body').on 'click', '#create-poll', @showPollForm
    $('body').on 'click', '#cancel-form', @hidePollForm

  showPollForm: ->
    $('.main-logo.pic, #header-left').hide()
    $('#poll-creator, #cancel-form').show()

  hidePollForm: ->
  	$('.main-logo.pic').show()
  	
  	$('#poll-creator, #cancel-form, #header-left, .main-logo.txt').hide()
  	if $(window).width() < 1024
  		$('.main-logo.pic').hide()
  		$('#header-left').show()



    


ready = ->
  Dashboard.init()
$(document).ready ready
$(document).on 'page:load', ready
