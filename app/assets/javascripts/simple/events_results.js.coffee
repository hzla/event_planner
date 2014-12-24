SimpleEventResults =
  init: ->
    $('.choice-header').click @expandColumn
    $('.simple-results .question-name').click @expandResultsTable
    $('.question-name').first().click()

  expandResultsTable: ->
    resultsTable = $(@).parents('.simple-choice').find('.simple-voter')
    $(@).parents('.simple-choice').css('border', 'none')
    columnCount = resultsTable.find('.choice-header').length + 1
    width = columnCount * 62 + 110
    $('.simple-results-header, .simple-choice-body').css('width' , "#{width}px")

  expandColumn: ->
    $(@).toggleClass('expanded')
    $(@).css('height', '60px').css('line-height', '30px')
    index = $(@).index()
    column = $(@).parents('.simple-question-results').find(".col-#{index}")
    question = $(@).parents('.simple-choice')
    if $(@).hasClass("expanded")   
      question.find('.cell:not(.poll-taker-name)').hide()
      column.show().css('width', '150px')
      question.find('.shortened-value').hide()
      question.find('.full-value').show()
    else
      question.find('.cell').show().attr('style', "")
      question.find('.shortened-value').show()
      question.find('.full-value').hide()

    
ready = ->
  SimpleEventResults.init()
$(document).ready ready
$(document).on 'page:load', ready
