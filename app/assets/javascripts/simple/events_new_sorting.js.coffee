SimpleNewEventSorting =
  init: ->
    @sortable() if $('#simple-events-form').length > 0

  sortable: ->
    list = $('#simple-events-form')[0]
    if $(window).width() > 1023
      new Sortable list, {
        draggable: '.question-info-container'
        onUpdate: SimpleNewEventSorting.reorderQuestionNums
        filter: '.ignore-drag'
      }
      choices = $('#text-choice-picker')[0]
      new Sortable choices, {
        draggable: '.text-choice'
        onUpdate: SimpleNewEventSorting.reassignLetters
        handle: '.draggable-container'
      }
    else
      choices = $('#text-choice-picker')[0]
      new Sortable choices, {
        draggable: '.text-choice'
        handle: '.text-choice-num'
        onUpdate: SimpleNewEventSorting.reassignLetters
      }

  reorderQuestionNums: ->
    count = 1
    $('.question-num').each ->
      $(@).text("#{count}.")
      count += 1

  reassignLetters: ->
    count = 1
    $('.text-choice').each ->
      $(@).find('.text-choice-num').text("#{String.fromCharCode(96 + count)}.")
      count += 1

ready = ->
  SimpleNewEventSorting.init()
$(document).ready ready
$(document).on 'turbolinks:load', ready
