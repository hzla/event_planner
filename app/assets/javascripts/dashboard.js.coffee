Dashboard =
  init: ->
    $('body').on 'click', '#create-poll', @showPollForm
    $('body').on 'click touchend', '#cancel-form', @hidePollForm
    $('body').on 'ajax:success', '#activation-form', @showActivation

  showActivation: (event, data) ->
    if data.activated 
      $('.activation-email.btn').val "Thanks! We'll be in touch!"
    else
      $('.activation-email.btn').val "Looks like you don't have access yet"
      setTimeout ->
        $('.activation-email.btn').val 'Submit'
      , 2000


  showPollForm: ->
    setTimeout ->
      $('.main-logo.pic, #header-left, .event').hide()
      $('.main-header-text').hide()
      $('#poll-creator, #cancel-form').show()
      $('.whos-going').removeClass("hidden")
      $(window).scrollTop(0)
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
