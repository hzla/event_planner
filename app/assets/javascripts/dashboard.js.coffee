Dashboard =
  init: ->
    $('body').on 'click touchend', '#create-poll', @showPollForm
    $('body').on 'click touchend', '#cancel-form', @hidePollForm
    $('body').on 'submit', '#new_event', @checkFields
    
  showPollForm: ->
    $('.main-logo.pic, #header-left').hide()
    $('#poll-creator, #cancel-form').show()
    $(window).scrollTop(0);

  hidePollForm: ->
  	$('.main-logo.pic').show()
  	
  	$('#poll-creator, #cancel-form, #header-left, .main-logo.txt').hide()
  	if $(window).width() < 1024
  		$('.main-logo.pic').hide()
  		$('#header-left').show()

  checkFields: ->
    name = $('#event_name').val()
    desc = $('#event_comment').val()
    if name == "" || desc == ""
      $('#event_name').css('border', '1px solid red') if name == ""
      $('#event_comment').css('border', '1px solid red') if desc == ""
      return false
    else
      return true




    


ready = ->
  Dashboard.init()
$(document).ready ready
$(document).on 'page:load', ready
