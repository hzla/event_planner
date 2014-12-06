SimpleNewEventUi =
  init: ->
    #for when to display the 'x' on the question
    $('body').on 'mouseenter', '.question-info-container', @showDelete
    $('body').on 'mouseleave', '.question-info-container', @hideDelete

    #adding and deleting text choices
    $('body').on 'click', '.cancel-choice', @cancelChoice
    $('body').on 'focus', '.text-choice.placeholder', @addChoice
    $('body').on 'click', '.add-choice', @addChoice

    #hide the add-another-question btn on mobile while adding choices
    if $(window).width() < 1023 
      $('body').on 'focus', '.text-choice-input', @hideBtns
      $('body').on 'unfocus blur', '.text-choice-input', @showBtns

  showDelete: ->
    if $(@).find('.date-choices').val() != "" || $(@).find('.text-choices').val() != "" 
      $(@).find('.delete-question-icon').show()

  hideDelete: ->
    $(@).find('.delete-question-icon').hide()

  cancelChoice: ->
    $(@).parents('.text-choice').remove()
    $('.text-choice-input').last().attr('placeholder', 'Add an option...')
    SimpleNewEventUi.reassignNumbers()

  addChoice: ->
    choice = $(@)
    if !choice.hasClass('text-choice')
      choice = $(@).parents('.text-choice')

    choice.find('.text-choice-input').attr('placeholder', 'Type an option...')
    choice.removeClass 'placeholder'
    addIcon = choice.find('.add-choice').clone() 
    cancelIcon = choice.find('.cancel-choice').clone()
    nextChoiceNum  = (choice.find('.text-choice-num').text().slice(0, -1)).charCodeAt(0) + 1
    nextChoice = "<div class='text-choice placeholder'>
            <div class='draggable-container'>
                <div class='draggable-top'></div>
                <div class='draggable-bottom'></div>
                <div class='text-choice-num'>#{String.fromCharCode(nextChoiceNum)}.</div>
              </div>
            <input class='text-choice-input' id='text_choice_#{nextChoiceNum}' name='text_choice_#{nextChoiceNum}' type='text' placeholder='Add Option...'>
          </div>"
    choice.after(nextChoice)
    $('.text-choice').last().append(addIcon)
    $('.text-choice').last().append(cancelIcon)
    $('#text-choice-picker').scrollTop(100000)

  hideBtns: ->
    $('.double.bottom-btn-container').hide()

  showBtns: ->
    $('.double.bottom-btn-container').show()

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
