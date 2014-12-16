#events related to submiting form and poll-overlay container

SimpleNewEventSubmit =
  init: ->
    $('.submit-simple-event').show()
    $('.submit-simple-event').click @submitSimpleEvent
    $('body').on 'submit', '#simple-events-form', @addQuestions
    $('body').on 'ajax:success', '#simple-events-form', @showEventUrl
    $('body').on 'click', '#poll-url-overlay', @hideEventUrl
    $('body').on 'click', '#get-poll-url', @showPollUrlContainer 

  addQuestions: ->
    if $('#questions').val() == ""  
      if $('#event_name').val() != "" && $('.question-info-container .poll-field').first().val() != ""
        $('#confirm-simple-event').click() #add last question if not confirmed
        $('.question-info-container .poll-field').each ->
          value = $(@).val()
          currentQuestions = $('#questions').val()
          newQuestions = currentQuestions + value + "<separator>"
          $('#questions').val newQuestions
      else
        $('#event_name').css 'border', '1px solid red' if $('#event_name').val() == ""
        $('.question-info-container .poll-field').css 'border', '1px solid red' if $('.question-info-container .poll-field').first().val() == ""
        setTimeout ->
          $('#event_name, .poll-field').attr('style', '')
        , 1000
        return false

  submitSimpleEvent: ->
    $('#simple-events-form').submit() if !$('.submit-simple-event').hasClass('inactive')

  hideEventUrl: (e) ->
    $(@).hide() if e.target == $('#poll-url-overlay')[0]

  showEventUrl: (e, data) ->
    event = $.parseJSON data.created_event
    poll = $.parseJSON data.poll
    pollUrl = "http://www.dinnerpoll.com" + event.routing_url
    pollTakeUrl = "http://www.dinnerpoll.com" + poll.url
    $('#poll-url-overlay').show()
    $('#copy-poll-url').attr('data-clipboard-text', pollUrl)
    $('#poll-url').val pollUrl
    $('#dashboard-btn').before("<a href='#{pollTakeUrl}'>
    <div id='take-poll-btn' class='btn blue-btn'>Take Poll</div>
    </a>") 
    $('#poll-url')[0].select()
    $('.submit-simple-event').addClass('inactive')
    $('#simple-event-btns').append("<div class='btn blue-btn btn-bot' id='get-poll-url'>Get Poll Link</div>")
    $('#simple-event-btns').append("<a href='/dashboard'><div class='btn black-btn btn-bot'>Back to Dashboard</div></a>")
      
  showPollUrlContainer: ->
    $('#poll-url-overlay').show()


ready = ->
  SimpleNewEventSubmit.init()
$(document).ready ready
$(document).on 'page:load', ready
