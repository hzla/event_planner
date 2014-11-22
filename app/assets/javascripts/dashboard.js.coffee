Dashboard =
  init: ->
    $('body').on 'click touchend', '#create-poll', @showPollForm
    $('body').on 'click touchend', '#cancel-form', @hidePollForm    
    
  showPollForm: ->
    setTimeout ->
      $('.main-logo.pic, #header-left, .event').hide()
      $('.main-header-text').hide()
      $('#poll-creator, #cancel-form').show()
      $('.whos-going').removeClass("hidden")
      $(window).scrollTop(0);
    , 300

  hidePollForm: ->
    $('.main-logo.pic, .event').show()
    $('#poll-creator, #cancel-form, #header-left, .main-logo.txt').hide()
    if $(window).width() < 1024
    	$('.main-logo.pic').hide()
    	$('#header-left').show()
    $('.whos-going').addClass('hidden')
    $('.main-header-text').show()

  

ready = ->
  Dashboard.init()
$(document).ready ready
$(document).on 'page:load', ready
