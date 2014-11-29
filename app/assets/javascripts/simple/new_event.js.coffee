SimpleNewEvent =
  init: ->
    # displaying date/text choice pickers
    $('.type .date-type').click @toggleEventDateForm
    $('body').on 'click', '.question-info-container', @editQuestion
    $('.text-type').click @toggleEventTextForm
    $('body').on 'click', '#cancel-simple-event', @clearEventDetails
    $('body').on 'click', '#cancel-type-container', @cancelTypeContainer

    # adding info from pickers to hidden fields
    $('body').on 'click', '#confirm-simple-event', @confirmEventDetails
    $('body').on 'submit', '#simple-events-form', @addQuestions 

    # adding more questions/choices to event creator
    $('body').on 'click', '#add-another-question', @addAnotherQuestion
    $('body').on 'click', '.cancel-choice', @cancelChoice
    $('body').on 'focus', '.text-choice.placeholder', @addChoice
    $('body').on 'click', '.add-choice', @addChoiceWithClick
    $('body').on 'keydown', '.text-choice-input', @nextOnEnter
    $('body').on 'keydown', @confirmDateOnEnter
    $('body').on 'keydown', '.active .poll-field', @showTypePicker
    @shown = false

    if $(window).width() < 1023
      $('body').on 'focus', '.text-choice-input', @hideBtns
      $('body').on 'unfocus blur', '.text-choice-input', @showBtns
    
    @questionCount = 1
    @initDatePicker()

    #show the done button
    $('.submit-simple-event').show()
    $('.submit-simple-event').click @submitSimpleEvent


  addChoiceWithClick: ->
    choice = $(@).parents('.text-choice')
    choice.find('.text-choice-input').attr('placeholder', 'Type an option...')
    choice.removeClass 'placeholder'
    addIcon = choice.find('.add-choice').clone() 
    cancelIcon = choice.find('.cancel-choice').clone()
    nextChoiceNum  = parseInt(choice.find('.text-choice-num').text().slice(0, -1)) + 1
    nextChoice = "<div class='text-choice placeholder'>
            <div class='text-choice-num'>#{nextChoiceNum}.</div>
            <input class='text-choice-input' id='text_choice_#{nextChoiceNum}' name='text_choice_#{nextChoiceNum}' type='text' placeholder='Add Option...'>
          </div>"
    choice.after(nextChoice)
    $('.text-choice').last().append(addIcon)
    $('.text-choice').last().append(cancelIcon)
    $('#text-choice-picker')[0].scrollTop = 100000

  hideBtns: ->
    $('.double.bottom-btn-container').hide()

  showBtns: ->
    $('.double.bottom-btn-container').show()

  showTypePicker: ->
    if SimpleNewEvent.shown == false
      $('.type-container').show()
      height = $('.type-container').height()
      $('.type-container').css('height', '0px').css('opacity', '0')
      $('.type-container').animate {
        opacity: 1
        height: height
      }, 750
      SimpleNewEvent.shown = true
  nextOnEnter: (e) ->
    if e.keyCode == 13
      next = $(@).parents('.text-choice').next().children('.text-choice-input')
      if next.parents('.text-choice').hasClass('placeholder')
        $('#confirm-simple-event').click()
      $(@).parents('.text-choice').next().children('.text-choice-input').focus()

  confirmDateOnEnter: (e) ->
    if e.keyCode == 13 && $('.date-picker-container:visible').length > 0
      $('#confirm-simple-event').click()

  editQuestion: ->
    pic = $(@).find('.type-pic:visible')
    clickedQuestion = $(@)
    if pic.length > 0
      if pic.hasClass('date-type')
        SimpleNewEvent.editDateQuestion clickedQuestion
      else
        SimpleNewEvent.editTextQuestion clickedQuestion

  cancelTypeContainer: (e) ->
    if SimpleNewEvent.questionCount > 1
      $('.question-info-container').last().remove()
      $('.question-info-container').last().addClass('active')
      $('.type-container').hide()

  editDateQuestion: (clickedQuestion) ->  
    dontClose = false
    if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1
      dontClose = true
      SimpleNewEvent.editMode = true
      $('.active').removeClass('active')
      clickedQuestion.addClass('active')
      datesToSet = clickedQuestion.find('.date-choices').val().split(",")
      parsedDates = $.map datesToSet, (val, i) ->
        new Date(val)

      $('#datepicker').datepicker('setDates', parsedDates)
      $('#add-another-question').hide()
      $('.date-picker-container, #simple-event-btns').show()
      $('.date-picker-container').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('.question-info-container:not(.active)').hide()
    if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0
      $('.question-info-container').show() if !dontClose
      $('#confirm-simple-event').click() if !dontClose
    $('#poll-creator')[0].scrollTop = 100000

  editTextQuestion: (clickedQuestion) ->
    dontClose = false
    if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1
      console.log "happened"      
      dontClose = true
      SimpleNewEvent.editMode = true
      $('.active').removeClass('active')
      clickedQuestion.addClass('active')
      textToSet = clickedQuestion.find('.text-choices').val().split("<separator>")
      $('#add-another-question').hide()
      $('#text-choice-picker, #simple-event-btns').show()
      $('#text-choice-picker').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('.active').after($('#text-choice-picker'))
      $.each textToSet, (i, choice) ->
        if choice != ""
          input = $("#text_choice_#{i + 1}")
          if input.parents('.text-choice').hasClass('placeholder')
            $('.add-choice:visible').click()
            input = $("#text_choice_#{i + 1}")
            input.val(choice)
          else
            input.val(choice)  
    if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0   
      $('#confirm-simple-event').click() if !dontClose 
    $('#poll-creator')[0].scrollTop = 100000

  submitSimpleEvent: ->
    $('#confirm-simple-event:visible').click()
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
    $('.text-choice-input').last().attr('placeholder', 'Add an option...')
    SimpleNewEvent.reassignNumbers()

  addChoice: ->
    choice = $(@)
    choice.find('.text-choice-input').attr('placeholder', 'Type an option...')
    choice.removeClass 'placeholder'
    addIcon = choice.find('.add-choice').clone() 
    cancelIcon = choice.find('.cancel-choice').clone()
    nextChoiceNum  = parseInt(choice.find('.text-choice-num').text().slice(0, -1)) + 1
    nextChoice = "<div class='text-choice placeholder'>
            <div class='text-choice-num'>#{nextChoiceNum}.</div>
            <input class='text-choice-input' id='text_choice_#{nextChoiceNum}' name='text_choice_#{nextChoiceNum}' type='text' placeholder='Add Option...'>
          </div>"
    choice.after(nextChoice)
    $('.text-choice').last().append(addIcon)
    $('.text-choice').last().append(cancelIcon)
    $('#text-choice-picker')[0].scrollTop = 100000

  reassignNumbers: ->
    count = 1
    $('.text-choice').each ->
      $(@).find('.text-choice-num').text("#{count}.")
      count += 1


  addAnotherQuestion: ->
    $('.active').removeClass('active')
    SimpleNewEvent.shown = false
    qc = SimpleNewEvent.questionCount
    nextQuestion = "<div class='question-info-container active'>
          <input class='poll-field' id='question_#{qc}' name='question__#{qc}' placeholder='Type question...' type='text'>
          <input class='date-choices' id='date_choice_list' name='date_choice_list_#{qc}' type='hidden'>
          <input class='text-choices' id='text_choice_list' name='text_choice_list_#{qc}' type='hidden'>
        </div>"
    $(@).before nextQuestion
    $('#add-another-question').hide()
    # $('.type-container').show()
    $('input.poll-field').last().focus()
    $('#poll-creator')[0].scrollTop = 100000
    $('.active .poll-field').keydown ->
      $('.poll-field').unbind('keydown')
      if SimpleNewEvent.shown == false
        console.log "trying"
        $('.type-container').show()
        height = $('.type-container').height()
        $('.type-container').css('height', '0px').css('opacity', '0')
        $('.type-container').animate {
          opacity: 1
          height: height
        }, 750
        $('#poll-creator')[0].scrollTop = 100000
        SimpleNewEvent.shown = true

  confirmEventDetails: ->
    currentQuestion = $('.question-info-container.active')
    $('.question-info-container').show()
    if $('.date-picker-container:visible').length > 0 #if clicking ok on datepicker
      
      icon = $('.type .date-type').clone()
      dates = $('#datepicker').datepicker('getDates')
      if dates.length < 2
        $('.date-picker-container').find('.picker-error').show()
        setTimeout ->
          $('.picker-error').hide()
        , 3000
        return
      $('.question-info-container.active').find('.date-choices').val dates
      # add calendar icon and reset datepicker
      currentQuestion.append icon 
      $('#datepicker').datepicker 'remove'
      SimpleNewEvent.initDatePicker()
    else # clicking ok on text choice picker
      icon = $('.type .text-type').clone()
      currentQuestion.find('.text-choices').val("")
      # add text choices to hidden input
      if $('#text_choice_1').val() == "" || $('#text_choice_2').val() == ""
        console.log 
        $('#text-choice-picker').find('.picker-error').show()
        setTimeout ->
          $('.picker-error').hide()
        , 3000
        return

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
    $('.type-container').hide()
    SimpleNewEvent.questionCount += 1
    $('.active').removeClass('active')
    

    # if the picker was opened by clickin on the small icon to edit an question
    if !SimpleNewEvent.editMode
      $('#add-another-question').click()


    if showTypePicker && SimpleNewEvent.editMode
      $('#add-another-question').hide()
      $('.type-container').show() 
      SimpleNewEvent.editMode = false
    else if SimpleNewEvent.editMode
      $('.type-container').hide()
      SimpleNewEvent.editMode = false

    # make the last question the active question
    $('.active').removeClass('active')
    $('.question-info-container').last().addClass('active')


  toggleEventDateForm: ->
    $('.poll-field').unbind('keydown')
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('.date-picker-container, .type-container').toggle()
      $('.date-picker-container').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('#poll-creator')[0].scrollTop = 100000
    else
      currentQuestion.css('border', '1px solid red')
      $('input.poll-field').last().focus()
      setTimeout ->
        currentQuestion.attr('style', 'none')
      , 1000

  toggleEventTextForm: ->
    $('.poll-field').unbind('keydown')
    SimpleNewEvent.reassignNumbers()
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('#text-choice-picker').show().removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('.type-container').hide()
      if $(window).width() > 1023
        offset = 140 + SimpleNewEvent.questionCount * 60
        $('#text-choice-picker').css('max-height', "calc(100vh - #{offset}px)" )
      $('#poll-creator')[0].scrollTop = 100000
      $('.text-choice-input').first().focus()
    else
      currentQuestion.css('border', '1px solid red')
      $('input.poll-field').last().focus()
      setTimeout ->
        currentQuestion.attr('style', 'none')
      , 1000
    

  closeEventForm: ->
    $('.date-picker-container, #text-choice-picker').hide()
    $('.type-container').show()

  initDatePicker: ->
    $("#datepicker").datepicker
      'multidate': true
      'startDate': new Date()
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
          
ready = ->
  SimpleNewEvent.init()
$(document).ready ready
$(document).on 'page:load', ready
