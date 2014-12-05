SimpleNewEventUi =
  init: ->
    @sortable() if $('#simple-events-form').length > 0

  sortable: ->
    list = $('#simple-events-form')[0]
    if $(window).width() > 1023
      new Sortable list, {
        draggable: '.question-info-container'
        onUpdate: SimpleNewEventUi.reorderQuestionNums
        filter: '.ignore-drag'
      }
      choices = $('#text-choice-picker')[0]
      new Sortable choices, {
        draggable: '.text-choice'
        onUpdate: SimpleNewEventUi.reassignNumbers
        handle: '.draggable-container'
      }
    else
      choices = $('#text-choice-picker')[0]
      new Sortable choices, {
        draggable: '.text-choice'
        handle: '.text-choice-num'
        onUpdate: SimpleNewEventUi.reassignNumbers
      }

  reorderQuestionNums: ->
    count = 1
    $('.question-num').each ->
      $(@).text("#{count}.")
      count += 1

  reassignNumbers: ->
    count = 1
    $('.text-choice').each ->
      $(@).find('.text-choice-num').text("#{String.fromCharCode(96 + count)}.")
      count += 1

ready = ->
  SimpleNewEventUi.init()
$(document).ready ready
$(document).on 'page:load', ready
