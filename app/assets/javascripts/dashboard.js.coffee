Dashboard =
  init: ->
    $('body').on 'click touchend', '#create-poll', @showPollForm
    $('body').on 'click touchend', '#cancel-form', @hidePollForm
    $('body').on 'submit', '#new_event', @checkFields
    $('body').on 'focus', '#event_start_time', @convertEventTime

  convertEventTime: ->
    @.type = 'date'
    $(@).focus
    
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
    desc = $('#event_desc').val()
    startTime = $('#event_start_time').val()
    if name == "" || desc == "" || startTime == ""
      $('#event_name').css('border', '1px solid red') if name == ""
      $('#event_desc').css('border', '1px solid red') if desc == ""
      $('#event_start_time').css('border', '1px solid red') if startTime == ""
      return false
    else
      return true




    


ready = ->
  Dashboard.init()
$(document).ready ready
$(document).on 'page:load', ready
