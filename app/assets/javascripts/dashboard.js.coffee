Dashboard =
  init: ->
    $('body').on 'click touchend', '#create-poll', @showPollForm
    $('body').on 'click touchend', '#cancel-form', @hidePollForm
    $('body').on 'submit', '.new_event, .edit_event', @checkFields
    $('body').on 'touchstart', '#event_start_date, #event_expiration', @convertEventDate
    $('body').on 'touchstart', '#event_start_time, #event_end_time', @convertEventTime
    $('body').on 'click', '.ongoing-tab', @showOngoing
    $('body').on 'click', '.reserved-tab', @showReserved
    @initSlider() if $("#range").length > 0
    $('#range').on 'slide', @changeShownValues
    @changeShownValues()
    @showOngoing()

  initSlider: ->
    $('#range').noUiSlider 
      start: [1020, 1140]
      connect: true
      range: 
        'min': 420
        'max': 1439
      step: 30
    $('#range').Link('lower').to($('.value-1'))
    $('#range').Link('upper').to($('.value-2'))

  changeShownValues: ->
    value1 = $('.value-1').text()
    convertedValue1 = Dashboard.slideTime(value1)
    $('#event_start_time').val convertedValue1
    value2 = $('.value-2').text()
    convertedValue2 = Dashboard.slideTime(value2)
    $('#event_end_time').val convertedValue2
    $('.shown-values').text "#{convertedValue1} - #{convertedValue2}"

  slideTime: (value) ->
    minutes0 = parseInt(value % 60, 10)
    hours0 = parseInt(value / 60 % 24, 10)
    time = Dashboard.getTime(hours0, minutes0);

  getTime: (hours, minutes) ->
    minutes = minutes + ""
    if hours < 12
      time = "AM";
    else 
      time = "PM";

    if hours == 0 
        hours = 12

    if hours > 12 
      hours = hours - 12

    if minutes.length == 1
      minutes = "0" + minutes
    
    hours + ":" + minutes + " " + time;

  showOngoing: ->
    $('.event').show()
    $('.event.reserved').hide()

  showReserved: ->
    $('.event').hide()
    $('.event.reserved').show()


  convertEventTime: ->
    if $(window).width() < 1024
      @.type = 'time'

  convertEventDate: ->
    if $(window).width() < 1024
      @.type = 'date'

  showPollForm: ->
    setTimeout ->
      $('.main-logo.pic, #header-left').hide()
      $('.main-header-text').hide()
      $('#poll-creator, #cancel-form').show()
      $('.whos-going').removeClass("hidden")
      $(window).scrollTop(0);
    , 300

  hidePollForm: ->
    $('.main-logo.pic').show()
    $('#poll-creator, #cancel-form, #header-left, .main-logo.txt').hide()
    if $(window).width() < 1024
    	$('.main-logo.pic').hide()
    	$('#header-left').show()
    $('.whos-going').addClass('hidden')
    $('.main-header-text').show()

  checkFields: ->
    name = $('#event_name').val()
    sd = $('#event_start_date').val()
    st = $('#event_start_time').val()
    et = $('#event_end_time').val()
    th = $('#event_threshold').val()
    if name == "" || sd == "" || st == "" || et == "" || th == ""
      $('#event_name').css('border', '1px solid red') if name == ""
      $('#event_start_date').css('border', '1px solid red') if sd == ""
      $('#event_start_time').css('border', '1px solid red') if st == ""
      $('#event_end_time').css('border', '1px solid red') if et == ""
      $('#event_threshold').css('border', '1px solid red') if th == ""
      console.log "error"
      console.log st
      console.log et
      return false
    else
      return true

ready = ->
  Dashboard.init()
$(document).ready ready
$(document).on 'page:load', ready
