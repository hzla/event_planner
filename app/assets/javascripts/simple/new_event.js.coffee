SimpleNewEvent =
  init: ->
    # displaying date/text choice pickers
    $('body').on 'click', '.type .date-type', @toggleEventDateForm
    $('body').on 'click', '.question-info-container', @editQuestion
    $('body').on 'click', '.type .text-type', @toggleEventTextForm
    $('body').on 'click', '#cancel-simple-event', @clearEventDetails
    $('body').on 'click', '#cancel-type-container', @cancelTypeContainer
    $('body').on 'click', '.delete-question-icon', @deleteQuestion
    $('body').on 'mouseenter', '.question-info-container', @showDelete
    $('body').on 'mouseleave', '.question-info-container', @hideDelete

    # adding info from pickers to hidden fields
    $('body').on 'click', '#confirm-simple-event', @confirmEventDetails
    $('body').on 'submit', '#simple-events-form', @addQuestions 

    # adding more questions/choices to event creator
    $('body').on 'click', '#add-another-question', @addAnotherQuestion
    $('body').on 'click', '.cancel-choice', @cancelChoice
    $('body').on 'focus', '.text-choice.placeholder', @addChoice
    $('body').on 'click', '.add-choice', @addChoiceWithClick
    $('body').on 'keydown', '#simple-events-form #event_name', @firstQuestionOnEnter
    $('body').on 'keydown', '.text-choice-input', @nextOnEnter
    $('body').on 'keydown', @eventsOnEnter
    $('body').on 'keydown', @nextTypeOnTab
    $('body').on 'keydown', '.active .poll-field', @showTypePicker
    $('body').on 'keydown', '.active .poll-field', @selectTypeOnTab
    @shown = false

    if $(window).width() < 1023
      $('body').on 'focus', '.text-choice-input', @hideBtns
      $('body').on 'unfocus blur', '.text-choice-input', @showBtns
    
    @questionCount = 1
    @initDatePicker()

    #show the done button
    $('.submit-simple-event').show()
    $('.submit-simple-event').click @submitSimpleEvent
    $('body').on 'ajax:success', '#simple-events-form', @showEventUrl
    $('body').on 'click', '#poll-url-overlay', @hideEventUrl
    $('body').on 'click', '#poll-url-container', @dontHideEventUrl
    @sortable() if $('#simple-events-form').length > 0
    $('body').on 'click', '#get-poll-url', @showPollUrlContainer

    #datepicker
    if $(window).width() > 1023
      $('#datepicker, #datepicker-2').datepicker().on 'changeMonth', @changeMonth
      $('#datepicker, #datepicker-2').datepicker().on 'changeDate', @changeDate
      $('#datepicker, #datepicker-2').datepicker().on 'clearDate', @clearDate
      @dateChangable = true

  hideEventUrl: ->
    $(@).hide()

  dontHideEventUrl: (e) ->
    e.stopPropagation()

  showEventUrl: (e, data) ->
    event = $.parseJSON data.created_event
    poll = $.parseJSON data.poll
    pollUrl = "http://www.dinnerpoll.com" + event.routing_url
    pollTakeUrl = "http://www.dinnerpoll.com" + poll.url
    $('#poll-url-overlay').show()
    $('#copy-poll-url').attr('data-clipboard-text', pollUrl)
    $('#poll-url').val pollUrl
    $('#dashboard-btn').before("<a href='#{pollTakeUrl}'>
    <div id='take-poll-btn' class='btn blue-btn'>Take Poll</div>
    </a>") 
    $('#poll-url')[0].select()
    $('.submit-simple-event').addClass('inactive')
    $('#simple-event-btns').append("<div class='btn blue-btn btn-bot' id='get-poll-url'>Get Poll Url</div>")
    $('#simple-event-btns').append("<a href='/dashboard'><div class='btn black-btn btn-bot'>Back to dashboard</div></a>")
      
  showPollUrlContainer: ->
    $('#poll-url-overlay').show()

  showDelete: ->
    if $(@).find('.date-choices').val() != "" || $(@).find('.text-choices').val() != "" 
      $(@).find('.delete-question-icon').show()

  hideDelete: ->
    $(@).find('.delete-question-icon').hide()

  deleteQuestion: (e) ->
    e.stopPropagation() 
    currentQuestion = $(@).parents('.question-info-container')
    if !currentQuestion.hasClass('active')
      currentQuestion.remove()
      SimpleNewEvent.reorderQuestionNums()
      return

    if $('.type-container:visible').length > 0
      currentQuestion.find('.poll-field').val("").focus()
      $(".type-container").hide()
      SimpleNewEvent.shown = false
    else if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0
      currentQuestion.find('.poll-field').val("").focus()
      SimpleNewEvent.initDatePicker()
      SimpleNewEvent.resetTextPicker()
      $('.type-container').show()
      $('#text-choice-picker, .date-picker-container').hide()
    else if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1
      $(@).parents('.question-info-container').remove() if $('.question-info-container').length > 1
      SimpleNewEvent.reorderQuestionNums()
    else

  reorderQuestionNums: ->
    count = 1
    $('.question-num').each ->
      $(@).text("#{count}.")
      count += 1

  firstQuestionOnEnter: (e) ->
    $('.submit-simple-event').removeClass('inactive') if $('.text-choices').val() != "" || $('.date-choices').val() != ""
    if e.keyCode == 13 && $(@).val() != ""
      $('.active .poll-field').focus()

  clearDate: (e) ->

  changeDate: (e) ->
    datepicker = $(e.currentTarget)
    
    if SimpleNewEvent.dateChangable 
      SimpleNewEvent.dateChangable = false
      dates = $('#datepicker').datepicker('getDates')
      dates2 = $('#datepicker-2').datepicker('getDates')
      if datepicker.attr('id') == 'datepicker-2'
        dates = dates2
      else 
        dates = dates
      parsedDates = $.map dates, (val, i) ->
        new Date(val)
      setTimeout ->
        SimpleNewEvent.dateChangable = true
      , 200

      if dates.length > 0
        $('#datepicker, #datepicker-2').datepicker('setDates', parsedDates)
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


  nextTypeOnTab: (e) ->
    if e.keyCode == 9 && $('.type').first().hasClass('selected')
      $('.selected').removeClass('selected')
      $('.type').last().addClass('selected')
      $('#main-header a').click ->
        return false
    else if e.keyCode == 9 && $('.type').last().hasClass('selected')
      $('.selected').removeClass('selected')
      $('.type').first().addClass('selected')

  selectTypeOnTab: (e) ->
     e.stopPropagation()
     if e.keyCode == 9
      $('input').blur()
      toSelect = $('.type:not(.selected)').first()
      $('.selected').removeClass('selected')
      toSelect.first().addClass('selected')

  sortable: ->
    list = $('#simple-events-form')[0]
    if $(window).width() > 1023
      new Sortable list, {
        draggable: '.question-info-container'
        onUpdate: SimpleNewEvent.reorderQuestionNums
        filter: '.ignore-drag'
      }
      choices = $('#text-choice-picker')[0]
      new Sortable choices, {
        draggable: '.text-choice'
        onUpdate: SimpleNewEvent.reassignNumbers
        handle: '.draggable-container'
      }
    else
      choices = $('#text-choice-picker')[0]
      new Sortable choices, {
        draggable: '.text-choice'
        handle: '.text-choice-num'
        onUpdate: SimpleNewEvent.reassignNumbers
      }
    
  addChoiceWithClick: ->
    choice = $(@).parents('.text-choice')
    choice.find('.text-choice-input').attr('placeholder', 'Type an option...')
    choice.removeClass 'placeholder'
    addIcon = choice.find('.add-choice').clone() 
    cancelIcon = choice.find('.cancel-choice').clone()
    nextChoiceNum  = ((choice.find('.text-choice-num').text().slice(0, -1)).charCodeAt(0) + 1) - 96
    nextChoice = "<div class='text-choice placeholder'>
            <div class='draggable-container'>
                <div class='draggable-top'></div>
                <div class='draggable-bottom'></div>
                <div class='text-choice-num'>#{String.fromCharCode(nextChoiceNum + 96)}.</div>
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

  showTypePicker: ->
    if SimpleNewEvent.shown == false && $('.date-picker-container:visible, #text-choice-picker:visible').length < 1 && $(@).val() != ""
      $('.type-container').show()
      height = $('.type-container').height()
      $('.type-container').css('height', '0px').css('opacity', '0')
      $('.type-container').animate {
        opacity: 1
        height: height
      }, 750, ->
        $('#poll-creator, #simple-events-form, body').scrollTop(100000)
      SimpleNewEvent.shown = true

  nextOnEnter: (e) ->
    if e.keyCode == 13 && $(@).val() != ""
      next = $(@).parents('.text-choice').next().children('.text-choice-input')
      if next.parents('.text-choice').hasClass('placeholder')
        $('#confirm-simple-event').click()
      $(@).parents('.text-choice').next().children('.text-choice-input').focus()

  eventsOnEnter: (e) ->
    if e.keyCode == 13 && $('.date-picker-container:visible').length > 0
      $('#confirm-simple-event').click()
    else if e.keyCode == 13 && $('.type-container:visible .type.selected').length > 0
      $('.type.selected .type-pic').first().click()
      $('.selected').removeClass('selected')
    $('#main-header a').unbind()

  editQuestion: ->
    pic = $(@).find('.type-pic:visible')
    clickedQuestion = $(@)
    if pic.length > 0
      if pic.attr('class').indexOf('date-type') >= 0
        SimpleNewEvent.editDateQuestion clickedQuestion
      else
        SimpleNewEvent.editTextQuestion clickedQuestion
    else
      $('.active').removeClass('active')
      $(@).addClass('active')
      $('.date-picker-container:visible, #text-choice-picker:visible').hide()
      SimpleNewEvent.shown = false

  cancelTypeContainer: (e) ->
    if SimpleNewEvent.questionCount > 1
      $('.question-info-container').last().remove()
      $('.question-info-container').last().addClass('active')
      $('.type-container').hide()

  editDateQuestion: (clickedQuestion) ->  
    dontClose = false
    clickedQuestion.find('input').focus()
    if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1
      dontClose = true
      SimpleNewEvent.editMode = true
      $('.active').removeClass('active')
      clickedQuestion.addClass('active')
      datesToSet = clickedQuestion.find('.date-choices').val().split(",")
      parsedDates = $.map datesToSet, (val, i) ->
        new Date(val)
      $('#datepicker, #datepicker-2').datepicker('setDates', parsedDates)
      #in order to make the second month go forward
      SimpleNewEvent.syncDate = false
      $('#datepicker-2 .next').first().click()
      SimpleNewEvent.syncDate = true
      $('#add-another-question').hide()
      $('.date-picker-container, #simple-event-btns').show()
      $('.date-picker-container').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('.question-info-container:not(.active)').hide()
      # $('.active').after($('.date-picker-container'))
    if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && clickedQuestion.hasClass('active')
      $('.question-info-container').show() if !dontClose
      $('#confirm-simple-event').click() if !dontClose
    else if $('.type-container:visible').length > 0
      $('.type-container').hide()
      clickedQuestion.click()
      SimpleNewEvent.shown = false
    else if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && !clickedQuestion.hasClass('active')
      $('#confirm-simple-event').click()
      if $('.picker-error:visible').length < 1
        clickedQuestion.click()
    $('#poll-creator, #simple-events-form, body').scrollTop(100000)

  editTextQuestion: (clickedQuestion) ->
    dontClose = false
    if $('#text-choice-picker:visible, .date-picker-container:visible, .type-container:visible').length < 1    
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
    if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && clickedQuestion.hasClass('active')   
      $('#confirm-simple-event').click() if !dontClose 
    else if $('.type-container:visible').length > 0
      $('.type-container').hide()
      clickedQuestion.click()
      SimpleNewEvent.shown = false
    else if $('#text-choice-picker:visible, .date-picker-container:visible').length > 0 && !clickedQuestion.hasClass('active')
      $('#confirm-simple-event').click()
      if $('.picker-error:visible').length < 1
        clickedQuestion.click()
    $('#poll-creator, #simple-events-form, body').scrollTop(100000)

  submitSimpleEvent: ->
    # $('#confirm-simple-event:visible').click()
    $('#simple-events-form').submit() if !$('.submit-simple-event').hasClass('inactive')

  addQuestions: ->
    if $('#questions').val() == ""  
      if $('#event_name').val() != "" && $('.question-info-container .poll-field').first().val() != ""
        $('.question-info-container .poll-field').each ->
          value = $(@).val()
          currentQuestions = $('#questions').val()
          newQuestions = currentQuestions + value + "<separator>"
          $('#questions').val newQuestions
      else
        $('#event_name').css 'border', '1px solid red' if $('#event_name').val() == ""
        $('.question-info-container .poll-field').css 'border', '1px solid red' if $('.question-info-container .poll-field').first().val() == ""
        setTimeout ->
          $('#event_name, .poll-field').attr('style', '')
        , 1000
        return false
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

  reassignNumbers: ->
    count = 1
    $('.text-choice').each ->
      $(@).find('.text-choice-num').text("#{String.fromCharCode(96 + count)}.")
      count += 1


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
    $('#add-another-question').hide()
    # $('.type-container').show()
    $('input.poll-field').last().focus()
    $('#poll-creator, #simple-events-form, body').scrollTop(100000)
    $('.active .poll-field').keydown ->
      # $('.poll-field').unbind('keydown')
      if SimpleNewEvent.shown == false && $('.date-picker-container:visible, #text-choice-picker:visible').length < 1
        $('.type-container').show()
        height = $('.type-container').height()
        $('.type-container').css('height', '0px').css('opacity', '0')
        $('.type-container').animate {
          opacity: 1
          height: height
        }, 750, ->
          $('#poll-creator, #simple-events-form, body').scrollTop(100000)
        SimpleNewEvent.shown = true

  confirmEventDetails: ->
    currentQuestion = $('.question-info-container.active')
    isEmpty = currentQuestion.find('.date-choices, .text-choices').val() == ""
    console.log currentQuestion.find('.date-choices, .text-choices').val()
    console.log isEmpty
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
    SimpleNewEvent.closeEventForm()
    $('.type-container').hide()
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


  toggleEventDateForm: ->
    icon = $('.type .date-type').first().clone()
    # $('.poll-field').unbind('keydown')
    SimpleNewEvent.initDatePicker()
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('.date-picker-container, .type-container').toggle()
      $('.date-picker-container').removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('#poll-creator, #simple-events-form, body').scrollTop(100000)
      currentQuestion.parents('.question-info-container').append icon
    else
      currentQuestion.css('border', '1px solid red')
      $('input.poll-field').last().focus()
      setTimeout ->
        currentQuestion.attr('style', 'none')
      , 1000

  toggleEventTextForm: ->
    icon = $('.type .text-type').first().clone()
    # $('.poll-field').unbind('keydown')
    SimpleNewEvent.resetTextPicker()
    SimpleNewEvent.reassignNumbers()
    currentQuestion = $('.question-info-container.active .poll-field')
    if currentQuestion.val() != ""
      $('.active').after($('#text-choice-picker'))
      $('#text-choice-picker').show().removeClass('animated fadeInDown').addClass('animated fadeInDown')
      $('.type-container').hide()
      $('#poll-creator, #simple-events-form, body').scrollTop(100000)
      $('.text-choice-input').first().focus()
      currentQuestion.parents('.question-info-container').append icon
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
    $('#datepicker, #datepicker-2').datepicker 'remove'
    $("#datepicker").datepicker
      'multidate': true
      'startDate': new Date()
    $("#datepicker-2").datepicker
      'multidate': true
      'startDate': new Date()
    $('.dow').parent().addClass('dow-row')
    if $(window).width() > 1023
      $('#datepicker .next').hide()
      $('#datepicker-2 .prev').css('display', 'none')
      $('#datepicker-2 .datepicker-switch').attr('colspan', 6)
      SimpleNewEvent.syncDate = false
      $('#datepicker-2 .next').first().click()
      SimpleNewEvent.syncDate = true
      $('.new.day').hide()

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
    SimpleNewEvent.reassignNumbers()
    $('.text-choice').remove()
    $('#text-choice-picker').append firstThreeChoiceInputs
    $('.text-choice').last().addClass('placeholder')
          
ready = ->
  SimpleNewEvent.init()
$(document).ready ready
$(document).on 'page:load', ready
