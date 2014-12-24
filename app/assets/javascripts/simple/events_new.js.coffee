SimpleNewEvent =
  init: ->
    # displaying date/text choice pickers
    $('body').on 'click', '.type .date-type', @toggleEventDateForm
    $('body').on 'click', '.type .text-type', @toggleEventTextForm
    $('body').on 'keydown', '.active .poll-field', @showTypePicker
    
    #Adding Questions
    $('body').on 'click', '.question-info-container', @editQuestion
    $('body').on 'click', '#add-another-question', @addAnotherQuestion
    $('body').on 'click', '.delete-question-icon', @deleteQuestion
    
    # Confirming question choices
    $('body').on 'click touchend', '#confirm-simple-event', @confirmEventDetails

    #datepicker
    @dateChangable = true
    @initDatePicker()
    if $(window).width() > 1023 #only show two datepickers on desktop 
      #sync the months and the dates
      $('#datepicker, #datepicker-2').datepicker().on 'changeMonth', @changeMonth
      $('#datepicker, #datepicker-2').datepicker().on 'changeDate', @changeDate

    @shown = false #the state of the typepicker, @showTypePicker will only trigger when shown = false
    @questionCount = 1
  
  toggleEventDateForm: ->
    icon = $('.type .date-type').first().clone()
    SimpleNewEvent.initDatePicker()
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('.date-picker-container, .type-container').toggle()
      $('.date-picker-container').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      # $('#poll-creator, #simple-events-form, body, #content-container').scrollTop(100000)
      currentQuestion.parents('.question-info-container').append icon
    else
      currentQuestion.css('border', '1px solid red')
      $('input.poll-field').last().focus()
      setTimeout ->
        currentQuestion.attr('style', 'none')
      , 1000

  toggleEventTextForm: ->
    icon = $('.type .text-type').first().clone()
    SimpleNewEvent.resetTextPicker()
    SimpleNewEvent.reassignLetters()
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('.active').after($('#text-choice-picker'))
      $('#text-choice-picker').show().removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('.type-container').hide()
      $('#poll-creator, #simple-events-form, body, #content-container').scrollTop(100000)
      $('.text-choice-input').first().focus()
      currentQuestion.parents('.question-info-container').append icon
    else
      currentQuestion.css('border', '1px solid red')
      $('input.poll-field').last().focus()
      setTimeout ->
        currentQuestion.attr('style', 'none')
      , 1000

  showTypePicker: ->
    if SimpleNewEvent.shown == false && $('.date-picker-container:visible, #text-choice-picker:visible').length < 1 && $(@).val() != ""
      $('.type-container').show()
      height = $('.type-container').height()
      $('.type-container').css('height', '0px').css('opacity', '0')
      $('.type-container').animate {
        opacity: 1
        height: height
      }, 750, ->
        $('#poll-creator, #simple-events-form, body, #content-container').scrollTop(100000)
      SimpleNewEvent.shown = true

  editQuestion: ->
    pic = $(@).find('.type-pic:visible')
    clickedQuestion = $(@)
    if pic.length > 0 # if this question can be edited, there will be a picture icon
      if pic.attr('class').indexOf('date-type') >= 0
        SimpleNewEvent.editDateQuestion clickedQuestion
      else
        SimpleNewEvent.editTextQuestion clickedQuestion
    else
      $('.active').removeClass('active')
      $(@).addClass('active')
      $('.date-picker-container:visible, #text-choice-picker:visible').hide()
      SimpleNewEvent.shown = false

  editDateQuestion: (clickedQuestion) ->  
    dontClose = false #whether or not this click event should close the text picker
    clickedQuestion.find('input').focus()
    if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1
      # if opening up the date picker editor
      dontClose = true
      SimpleNewEvent.editMode = true
      $('.active').removeClass('active')
      clickedQuestion.addClass('active')
      #set the dates from the hidden input fields
      datesToSet = clickedQuestion.find('.date-choices').val().split(",")
      parsedDates = $.map datesToSet, (val, i) ->
        new Date(val)
      
      $('#datepicker, #datepicker-2').datepicker('setDates', parsedDates)
      # setting the dates causes the datepickers to be on the same month, 
      # so make the second month go forward
      SimpleNewEvent.syncDate = false
      $('#datepicker-2 .next').first().click()
      SimpleNewEvent.syncDate = true

      $('.date-picker-container, #simple-event-btns').show()
      $('.date-picker-container').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      
      # for some reason, shifting the location of the datepicker div breaks the datepicker 
      # so hide all other question info containers to achieve the effect that the datepicker 
      # is expanding to push other questions down
      $('.question-info-container:not(.active)').hide()
    
    if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && clickedQuestion.hasClass('active')
      # if closing datepicker
      $('.question-info-container').show() if !dontClose
      $('#confirm-simple-event').click() if !dontClose
    else if $('.type-container:visible').length > 0
      # if opening datepicker editor while picking type for another question
      $('.type-container').hide()
      clickedQuestion.click()
      SimpleNewEvent.shown = false
    else if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && !clickedQuestion.hasClass('active')
      # if opening datepicker editor while editing another question
      $('#confirm-simple-event').click()
      if $('.picker-error:visible').length < 1
        clickedQuestion.click()
    $('#poll-creator, #simple-events-form, body, #content-container').scrollTop(100000)

  editTextQuestion: (clickedQuestion) ->
    dontClose = false #whether or not this click event should close the text picker
    if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1    
      # if opening up the text question editor ^
      dontClose = true
      SimpleNewEvent.editMode = true
      
      # make this question the current active question
      $('.active').removeClass('active')
      clickedQuestion.addClass('active')
      
      # fade in the text-picker
      $('#text-choice-picker, #simple-event-btns').show()
      $('#text-choice-picker').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      
      # loop through the hidden text choices and fill out text picker manually
      textToSet = clickedQuestion.find('.text-choices').val().split("<separator>")
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

    else if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && clickedQuestion.hasClass('active')   
      # if closing the text-question-editor
      $('#confirm-simple-event').click() if !dontClose 
    else if $('.type-container:visible').length > 0
      # if trying to open the editor while the type container is visible
      $('.type-container').hide()
      clickedQuestion.click()
      SimpleNewEvent.shown = false
    else if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && !clickedQuestion.hasClass('active')
      #if trying to open the editor while editing another question
      $('#confirm-simple-event').click()
      if $('.picker-error:visible').length < 1
        clickedQuestion.click()
    $('#poll-creator, #simple-events-form, body, #content-container').scrollTop(100000)

  addAnotherQuestion: ->
    $('.active').removeClass('active')
    SimpleNewEvent.shown = false
    qc = $('.question-info-container').length + 1
    nextQuestion = "<div class='question-info-container active'>
          <div class='question-num no-mobile'>#{qc}.</div>
          <input class='poll-field' id='question_#{qc}' name='question__#{qc}' placeholder='Type your question...' type='text'>
          <input class='date-choices' id='date_choice_list' name='date_choice_list_#{qc}' type='hidden'>
          <input class='text-choices' id='text_choice_list' name='text_choice_list_#{qc}' type='hidden'>
        </div>"
    $(@).before nextQuestion
    $('.question-info-container.active').append $('.delete-question-icon').first().clone()
    $('input.poll-field').last().focus()
    $('#poll-creator, #simple-events-form, body, #content-container').scrollTop(100000)
    $('.active .poll-field').keydown ->
      if SimpleNewEvent.shown == false && $('.date-picker-container:visible, #text-choice-picker:visible').length < 1
        $('.type-container').show()
        height = $('.type-container').height()
        $('.type-container').css('height', '0px').css('opacity', '0')
        $('.type-container').animate {
          opacity: 1
          height: height
        }, 750, ->
          $('#poll-creator, #simple-events-form, body, #content-container').scrollTop(100000)
        SimpleNewEvent.shown = true

  deleteQuestion: (e) ->
    e.stopPropagation() 
    currentQuestion = $(@).parents('.question-info-container')
    if !currentQuestion.hasClass('active') 
      currentQuestion.remove()
      SimpleNewEvent.reorderQuestionNums()
      return

    if $('.type-container:visible').length > 0 
      # reset the question name if deleting while picking type
      currentQuestion.find('.poll-field').val("").focus()
      $(".type-container").hide()
      SimpleNewEvent.shown = false
    else if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0
      # reset question name and picked choices if deleting while picking choices
      currentQuestion.find('.poll-field').val("").focus()
      SimpleNewEvent.initDatePicker()
      SimpleNewEvent.resetTextPicker()
      $('.type-container').show()
      $('#text-choice-picker, .date-picker-container').hide()
    else if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1
      # remove question if there are no pickers visible and there's more than 1 question total
      $(@).parents('.question-info-container').remove() if $('.question-info-container').length > 1
      SimpleNewEvent.reorderQuestionNums()
    else

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

  changeDate: (e) ->
    datepicker = $(e.currentTarget)    
    if SimpleNewEvent.dateChangable 
      SimpleNewEvent.dateChangable = false
      dates = $('#datepicker').datepicker('getDates')
      dates2 = $('#datepicker-2').datepicker('getDates')
      
      # the dates to set should be the dates from the clicked datepicker
      if datepicker.attr('id') == 'datepicker-2'
        dates = dates2
      else 
        dates = dates

      # set the dates
      parsedDates = $.map dates, (val, i) ->
        new Date(val)
      setTimeout ->
        SimpleNewEvent.dateChangable = true
      , 200
      if dates.length > 0
        $('#datepicker, #datepicker-2').datepicker('setDates', parsedDates)
        # change the months on the datepickers so they are two consecutive months
        if datepicker.attr('id') == "datepicker-2"
          SimpleNewEvent.syncDate = false
          $('#datepicker .prev').first().click()
          setTimeout ->
            SimpleNewEvent.syncDate = true
          , 200
        else
          SimpleNewEvent.syncDate = false
          $('#datepicker-2 .next').first().click()
          setTimeout ->
            SimpleNewEvent.syncDate = true
          , 200
      if $('#datepicker').datepicker('getDates').length > 1 && $('#event_name').val() != ""
        #if the poll is ready to be submitted
        $('.submit-simple-event').removeClass('inactive')
  changeMonth: (e) ->
    datepicker = $(e.currentTarget)
    currentMonth = e.date.getMonth()
    if SimpleNewEvent.syncDate
      if datepicker.attr('id') == "datepicker-2" 
        SimpleNewEvent.syncDate = false
        $('#datepicker .next').first().click()
        SimpleNewEvent.syncDate = true
      else
        SimpleNewEvent.syncDate = false
        $('#datepicker-2 .prev').first().click()
        SimpleNewEvent.syncDate = true
  
  confirmEventDetails: ->
    currentQuestion = $('.question-info-container.active')
    isEmpty = currentQuestion.find('.date-choices, .text-choices').val() == ""
    $('.question-info-container').show()
    if $('.date-picker-container:visible').length > 0 #if clicking ok on datepicker
      
      dates = $('#datepicker').datepicker('getDates')
      if dates.length < 2
        $('.date-picker-container').find('.picker-error').show()
        setTimeout ->
          $('.picker-error').hide()
        , 3000
        return
      $('.question-info-container.active').find('.date-choices').val dates
      # add calendar icon and reset datepicker
      $('#datepicker').datepicker 'remove'
      SimpleNewEvent.initDatePicker()
    else # clicking ok on text choice picker
      currentQuestion.find('.text-choices').val("")
      # add text choices to hidden input
      if $('#text_choice_1').val() == "" || $('#text_choice_2').val() == ""  
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

      SimpleNewEvent.resetTextPicker()

    #logic for what to hide and what to show  
    $('.submit-simple-event').removeClass('inactive') if $('#event_name').val() != ""
    showTypePicker = true if $('.type-container:visible').length > 0 
    $('.date-picker-container, #text-choice-picker').hide()
    SimpleNewEvent.questionCount += 1
    $('.active').removeClass('active')
    SimpleNewEvent.reorderQuestionNums()
    SimpleNewEvent.questionCount = $(".question-info-container").length
    
    # if the picker was opened by clickin on the small icon to edit an question
    # only add a new question if not editing, or if you clicked to create another question while editing
    # and if the last question isn't blank
    if (!SimpleNewEvent.editMode || isEmpty) && $('.question-info-container .poll-field').last().val() != ""
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
    
  #resetting date/text pickers

  initDatePicker: ->
    $('#datepicker, #datepicker-2').datepicker 'remove'
    $("#datepicker").datepicker
      'multidate': true
      'startDate': new Date()
    $("#datepicker-2").datepicker
      'multidate': true
      'startDate': new Date()
    $('.dow').parent().addClass('dow-row')
    
    if $(window).width() > 1023
      $('#datepicker .next, #datepicker-2 .prev').hide()
      $('#datepicker-2 .datepicker-switch').attr('colspan', 6)
      SimpleNewEvent.syncDate = false
      $('#datepicker-2 .next').first().click()
      SimpleNewEvent.syncDate = true
      $('.new.day').hide()

  resetTextPicker: ->
    $('.text-choice-input').val("")
    firstThreeChoiceInputs = $('.text-choice:lt(3)').clone()
    SimpleNewEvent.reassignLetters()
    $('.text-choice').remove()
    $('#text-choice-picker').append firstThreeChoiceInputs
    $('.text-choice').last().addClass('placeholder')
          
ready = ->
  SimpleNewEvent.init()
$(document).ready ready
$(document).on 'page:load', ready
