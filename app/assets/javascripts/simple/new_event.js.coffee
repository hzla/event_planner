NewEvent =
  init: ->
    # tutorial flow
    $('.date-type').click @toggleEventDateForm
    $('.text-type').click @toggleEventTextForm
    $('body').on 'click', '#cancel-simple-event', @clearEventDetails
    $('body').on 'click', '#confirm-simple-event', @confirmEventDetails
    $('body').on 'click', '#add-another-question', @addAnotherQuestion
    $('body').on 'click', '.cancel-choice', @cancelChoice
    $('body').on 'click', '.add-choice', @addChoice
    $('body').on 'submit', '#simple-events-form', @addQuestions 
    @questionCount = 1
    @initDatePicker()
    $('.submit-simple-event').show()
    $('.submit-simple-event').click @submitSimpleEvent

  submitSimpleEvent: ->
    $('#simple-events-form').submit()


  addQuestions: ->
    if $('#questions').val() == ""  
      $('.question-info-container .poll-field').each ->
        value = $(@).val()
        currentQuestions = $('#questions').val()
        newQuestions = currentQuestions + value + ","
        $('#questions').val newQuestions



  cancelChoice: ->
    $(@).parents('.text-choice').remove()
    NewEvent.reassignNumbers()

  addChoice: ->
    choice = $(@).parents('.text-choice')
    choice.removeClass 'placeholder'
    addIcon = choice.find('.add-choice').clone() 
    cancelIcon = choice.find('.cancel-choice').clone()
    nextChoiceNum  = parseInt(choice.find('.text-choice-num').text().slice(0, -1)) + 1
    nextChoice = "<div class='text-choice placeholder'>
            <div class='text-choice-num'>#{nextChoiceNum}.</div>
            <input class='text-choice-input' id='text_choice_#{nextChoiceNum}' name='text_choice_#{nextChoiceNum}' type='text'>
          </div>"
    choice.after(nextChoice)
    $('.text-choice').last().append(addIcon)
    $('.text-choice').last().append(cancelIcon)

  reassignNumbers: ->
    count = 1
    $('.text-choice').each ->
      $(@).find('.text-choice-num').text("#{count}.")
      count += 1


  addAnotherQuestion: ->
    qc = NewEvent.questionCount
    nextQuestion = "<div class='question-info-container active'>
          <input class='poll-field' id='question_#{qc}' name='question__#{qc}' placeholder='Type question...' type='text'>
          <input class='date-choices' id='date_choice_list' name='date_choice_list_#{qc}' type='hidden'>
          <input class='text-choices' id='text_choice_list' name='text_choice_list_#{qc}' type='hidden'>
        </div>"
    $(@).before nextQuestion
    $('#add-another-question').hide()
    $('.type-container').show()

  confirmEventDetails: ->
    currentQuestion = $('.question-info-container.active')
    if currentQuestion.find('.poll-field').val() == ""
      currentQuestion.find('.poll-field').css('border', '1px solid red')
    else
      currentQuestion.find('.poll-field').attr('style', '')

      if $('#datepicker:visible').length > 0
        dates = $('#datepicker').datepicker('getDates')
        $('.question-info-container.active').find('.date-choices').val dates
      else
        $('.text-choice-input').each ->
          value = $(@).val()
          currentChoices = currentQuestion.find('.text-choices').val()
          newChoices = currentChoices + value + ","
          currentQuestion.find('.text-choices').val newChoices

     
      $('#datepicker').datepicker 'remove'
      NewEvent.initDatePicker()
      
      NewEvent.closeEventForm()
      $('#add-another-question').show()
      $('.type-container').hide()
      NewEvent.questionCount += 1
      $('.active').removeClass('active')

  toggleEventDateForm: ->
    $('#datepicker, .bottom-btn-container, .type-container').toggle()

  toggleEventTextForm: ->
    $('#text-choice-picker, .bottom-btn-container, .type-container').toggle()
    offset = 140 + NewEvent.questionCount * 60
    $('#text-choice-picker').css('height', "calc(100vh - #{offset}px)" )

  closeEventForm: ->
    $('#datepicker, #text-choice-picker, .bottom-btn-container').hide()
    $('.type-container').show()

  initDatePicker: ->
    $("#datepicker").datepicker
      'multidate': true
    $('.dow').parent().addClass('dow-row')

  clearEventDetails: ->
    $('#datepicker').datepicker 'remove'
    NewEvent.initDatePicker()
    NewEvent.closeEventForm()
    
ready = ->
  NewEvent.init()

$(document).ready ready
$(document).on 'page:load', ready
