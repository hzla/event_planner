SimpleNewEventKeydown =
  init: ->
    #move to the first question if pressing enter from event name field
    $('body').on 'keydown', '#simple-events-form #event_name', @firstQuestionOnEnter
    
    #cycle through event types with tab
    $('body').on 'keydown', @nextTypeOnTab
    $('body').on 'keydown', '.active .poll-field', @selectTypeOnTab

    #select type with enter, finish text/datepicker with enter, 
    $('body').on 'keydown', @eventsOnEnter
    $('body').on 'keydown', '.text-choice-input', @nextOnEnter
    $('body').on 'keydown', '.text-choice-input', @checkIfPollDone

  checkIfPollDone: (e) ->
    if $('.text-choice-input').first().val() != "" && $($('.text-choice-input')[1]).val() != "" && $('#event_name').val() != ""
      $('.submit-simple-event').removeClass('inactive')
    
  firstQuestionOnEnter: (e) ->
    $('.submit-simple-event').removeClass('inactive') if $('.text-choices').val() != "" || $('.date-choices').val() != ""
    if e.keyCode == 13 && $(@).val() != ""
      $('.active .poll-field').focus()

  nextTypeOnTab: (e) ->
    if e.keyCode == 9 && $('.type').first().hasClass('selected')
      $('.selected').removeClass('selected')
      $('.type').last().addClass('selected')
    else if e.keyCode == 9 && $('.type').last().hasClass('selected')
      $('.selected').removeClass('selected')
      $('.type').first().addClass('selected')
    $('#dashboard-link').blur()

  selectTypeOnTab: (e) ->
    e.stopPropagation()
    if e.keyCode == 9
      $('input').blur()
      toSelect = $('.type:not(.selected)').first()
      $('.selected').removeClass('selected')
      toSelect.first().addClass('selected')
    $('#dashboard-link').blur()

  eventsOnEnter: (e) ->
    if e.keyCode == 13 && $('.date-picker-container:visible').length > 0
      $('#confirm-simple-event').click()     
    else if e.keyCode == 13 && $('.type-container:visible .type.selected').length > 0
      $('.type.selected .type-pic').first().click()
      $('.selected').removeClass('selected')

  nextOnEnter: (e) ->
    if e.keyCode == 13 && $(@).val() != ""
      next = $(@).parents('.text-choice').next().children('.text-choice-input')
      if next.parents('.text-choice').hasClass('placeholder')
        $('#confirm-simple-event').click()
      $(@).parents('.text-choice').next().children('.text-choice-input').focus()

ready = ->
  SimpleNewEventKeydown.init()
$(document).ready ready
$(document).on 'page:load', ready
