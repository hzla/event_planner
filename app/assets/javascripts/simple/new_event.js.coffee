SimpleNewEvent =
  init: ->
    # displaying date/text choice pickers
    $('.type .date-type').click @toggleEventDateForm
    $('body').on 'click', '.question-info-container .date-type', @editDateQuestion
    $('body').on 'click', '.question-info-container .text-type', @editTextQuestion
    $('.text-type').click @toggleEventTextForm
    $('body').on 'click', '#cancel-simple-event', @clearEventDetails
    $('body').on 'click', '#cancel-type-container', @cancelTypeContainer

    # adding info from pickers to hidden fields
    $('body').on 'click', '#confirm-simple-event', @confirmEventDetails
    $('body').on 'submit', '#simple-events-form', @addQuestions 

    # adding more questions/choices to event creator
    $('body').on 'click', '#add-another-question', @addAnotherQuestion
    $('body').on 'click', '.cancel-choice', @cancelChoice
    $('body').on 'click', '.add-choice', @addChoice
    
    @questionCount = 1
    @initDatePicker()

    #show the done button
    $('.submit-simple-event').show()
    $('.submit-simple-event').click @submitSimpleEvent

  cancelTypeContainer: ->
    if SimpleNewEvent.questionCount > 1
      $('.question-info-container').last().remove()
      $('.question-info-container').last().addClass('active')
      $('.type-container').hide()
      $('#add-another-question').show()

  editDateQuestion: ->
    if $('#text-choice-picker:visible, #datepicker:visible, .type-container:visible').length < 1
      SimpleNewEvent.editMode = true
      $('.active').removeClass('active')
      clickedQuestion = $(@).parents(".question-info-container")
      clickedQuestion.addClass('active')
      datesToSet = clickedQuestion.find('.date-choices').val().split(",")
      parsedDates = $.map datesToSet, (val, i) ->
        new Date(val)

      $('#datepicker').datepicker('setDates', parsedDates)
      $('#add-another-question').hide()
      $('#datepicker, #simple-event-btns').show()

  editTextQuestion: ->
    if $('#text-choice-picker:visible, #datepicker:visible, .type-container:visible').length < 1
      SimpleNewEvent.editMode = true
      $('.active').removeClass('active')
      clickedQuestion = $(@).parents(".question-info-container")
      clickedQuestion.addClass('active')
      textToSet = clickedQuestion.find('.text-choices').val().split("<separator>")
      $('#add-another-question').hide()
      $('#text-choice-picker, #simple-event-btns').show()
      $.each textToSet, (i, choice) ->
        if choice != ""
          input = $("#text_choice_#{i + 1}")
          if input.attr('disabled') == "disabled" 
            $('.add-choice:visible').click()
            input = $("#text_choice_#{i + 1}")
            input.val(choice)
          else
            input.val(choice)      

  submitSimpleEvent: ->
    $('#simple-events-form').submit()

  addQuestions: ->
    if $('#questions').val() == ""  
      $('.question-info-container .poll-field').each ->
        value = $(@).val()
        currentQuestions = $('#questions').val()
        newQuestions = currentQuestions + value + "<separator>"
        $('#questions').val newQuestions

  cancelChoice: ->
    $(@).parents('.text-choice').remove()
    SimpleNewEvent.reassignNumbers()

  addChoice: ->
    choice = $(@).parents('.text-choice')
    choice.removeClass 'placeholder'
    choice.find('input').removeAttr('disabled')
    addIcon = choice.find('.add-choice').clone() 
    cancelIcon = choice.find('.cancel-choice').clone()
    nextChoiceNum  = parseInt(choice.find('.text-choice-num').text().slice(0, -1)) + 1
    nextChoice = "<div class='text-choice placeholder'>
            <div class='text-choice-num'>#{nextChoiceNum}.</div>
            <input class='text-choice-input' id='text_choice_#{nextChoiceNum}' name='text_choice_#{nextChoiceNum}' type='text' disabled='disabled'>
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
    $('.active').removeClass('active')
    qc = SimpleNewEvent.questionCount
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
   
    if $('#datepicker:visible').length > 0 #if clicking ok on datepicker
      icon = $('.type .date-type').clone()
      dates = $('#datepicker').datepicker('getDates')
      $('.question-info-container.active').find('.date-choices').val dates
      # add calendar icon and reset datepicker
      currentQuestion.append icon 
      $('#datepicker').datepicker 'remove'
      SimpleNewEvent.initDatePicker()
    else # clicking ok on text choice picker
      icon = $('.type .text-type').clone()
      currentQuestion.find('.text-choices').val("")
      # add text choices to hidden input
      $('.text-choice-input').each ->
        value = $(@).val()
        currentChoices = currentQuestion.find('.text-choices').val()
        newChoices = currentChoices + value + "<separator>"
        currentQuestion.find('.text-choices').val newChoices
      currentQuestion.append icon 
      SimpleNewEvent.resetTextPicker()

    #logic for what to hide and what to show  
    showTypePicker = true if $('.type-container:visible').length > 0 
    SimpleNewEvent.closeEventForm()
    $('#add-another-question').show()
    $('.type-container').hide()
    SimpleNewEvent.questionCount += 1
    $('.active').removeClass('active')

    # if the picker was opened by clickin on the small icon to edit an question
    if showTypePicker && SimpleNewEvent.editMode
      $('#add-another-question').hide()
      $('.type-container').show() 
      SimpleNewEvent.editMode = false
    else if SimpleNewEvent.editMode
      $('#add-another-question').show()
      $('.type-container').hide()
      SimpleNewEvent.editMode = false

    # make the last question the active question
    $('.active').removeClass('active')
    $('.question-info-container').last().addClass('active')


  toggleEventDateForm: ->
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('#datepicker, #simple-event-btns, .type-container').toggle()
    else
      currentQuestion.css('border', '1px solid red')
      setTimeout ->
        currentQuestion.attr('style', 'none')
      , 1000

  toggleEventTextForm: ->
    SimpleNewEvent.reassignNumbers()
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('#text-choice-picker, #simple-event-btns, .type-container').toggle()
      offset = 140 + SimpleNewEvent.questionCount * 60
      $('#text-choice-picker').css('height', "calc(100vh - #{offset}px)" )
    else
      currentQuestion.css('border', '1px solid red')
      setTimeout ->
        currentQuestion.attr('style', 'none')
      , 1000
    

  closeEventForm: ->
    $('#datepicker, #text-choice-picker, #simple-event-btns').hide()
    $('.type-container').show()

  initDatePicker: ->
    $("#datepicker").datepicker
      'multidate': true
    $('.dow').parent().addClass('dow-row')

  clearEventDetails: ->
    $('#datepicker').datepicker 'remove'
    SimpleNewEvent.resetTextPicker()
    showTypePicker = true if $('.type-container:visible').length > 0  
    SimpleNewEvent.initDatePicker()
    SimpleNewEvent.closeEventForm()
    if showTypePicker && SimpleNewEvent.editMode
      $('.type-container').show() 
      SimpleNewEvent.editMode = false
    else if SimpleNewEvent.editMode
      $('#add-another-question').show()
      $('.type-container').hide()
      SimpleNewEvent.editMode = false
    else
    $('.active').removeClass('active')
    $('.question-info-container').last().addClass('active')

  resetTextPicker: ->
    $('.text-choice-input').val("")
    firstThreeChoiceInputs = $('.text-choice:lt(3)').clone()
    $('.text-choice').remove()
    $('#text-choice-picker').append firstThreeChoiceInputs
    $('.text-choice').last().addClass('placeholder')
    $('.text-choice-input').last().attr('disabled', 'disabled')
          
ready = ->
  SimpleNewEvent.init()
$(document).ready ready
$(document).on 'page:load', ready
