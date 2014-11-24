NewEvent =
  init: ->
    # tutorial flow
    $('.tut-1 #tut-right').click @goNextTutStep
    $('.tut-2 #tut-left').click @goBackTutStep
    $('.tut-2 #tut-right').click @finishTut
    $('#event_threshold').change @showNextArrow

    # validation
    $('body').on 'submit', '.new_event, .edit_event', @checkFields

    #so that mobile time fields can have placeholder text
    $('body').on 'focus', '#event_start_date, #event_expiration', @convertEventDate

    #slider
    @initSlider() if $("#range").length > 0
    $('#range').on 'slide', @changeShownValues
    @changeShownValues()

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
    convertedValue1 = NewEvent.slideTime(value1)
    $('#event_start_time').val convertedValue1
    value2 = $('.value-2').text()
    convertedValue2 = NewEvent.slideTime(value2)
    $('#event_end_time').val convertedValue2
    $('.shown-values').text "#{convertedValue1} - #{convertedValue2}"

  slideTime: (value) ->
    minutes = parseInt(value % 60, 10)
    hours = parseInt(value / 60 % 24, 10)
    time = NewEvent.getTime(hours, minutes)

  getTime: (hours, minutes) ->
    minutes = minutes + ""
    if hours < 12
      time = "AM"
    else
      time = "PM"
    if hours == 0
        hours = 12
    if hours > 12
      hours = hours - 12
    if minutes.length == 1
      minutes = "0" + minutes
    hours + ":" + minutes + " " + time

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
      return false
    else
      return true

  convertEventDate: ->
    if $(window).width() < 1024
      @.type = 'date'

ready = ->
  NewEvent.init()

$(document).ready ready
$(document).on 'page:load', ready
