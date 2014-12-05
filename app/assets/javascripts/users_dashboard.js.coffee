Dashboard =
  init: ->
    $('body').on 'click', '#create-poll', @showEventTypepicker
    $('body').on 'click', '#event-typepicker-overlay, #cancel-typepicker' ,@hideEventTypepicker
    $('body').on 'click', '#show-poll-form', @showPollForm
    $('body').on 'click touchend', '#cancel-form:not(.simple-form)', @hidePollForm
    $('body').on 'ajax:success', '#activation-form', @showActivation

  showActivation: (event, data) ->
    if data.activated 
      $('.activation-email.btn').val "Thanks! We'll be in touch!"
      $('.act-text.success-text').show()
    else
      $('.activation-email.btn').val "Looks like you don't have access yet"
      $('.act-text.failure-text').show()
      setTimeout ->
        $('.activation-email.btn').val 'Submit'
      , 2000

  showEventTypepicker:  ->
    $('#event-typepicker-overlay').show()

  hideEventTypepicker: (e) ->
    if e.target == $('#event-typepicker-overlay')[0] || e.target == $('#cancel-typepicker')[0]
      $('#event-typepicker-overlay').hide()

  showPollForm: ->
    setTimeout ->
      $('#event-typepicker-overlay').hide()
      $('.main-logo.pic, #header-left, .event, .tutorial').hide()
      $('.main-header-text').hide()
      $('.bottom-btn-container').first().hide()
      $('#poll-creator, #cancel-form').show()
      $('.whos-going').removeClass("hidden")
      $('#events').hide()
      $(window).scrollTop(0)
    , 300

  hidePollForm: ->
    $('.main-logo.pic, .event').show()
    $('#poll-creator, #cancel-form, #header-left, .main-logo.txt').hide()
    $('#events').show()
    $('.bottom-btn-container').first().show()
    if $(window).width() < 1024
      $('.main-logo.pic').hide()
      $('#header-left').show()
    $('.whos-going').addClass('hidden')
    $('.main-header-text').show()

ready = ->
  Dashboard.init()
$(document).ready ready
$(document).on 'page:load', ready
