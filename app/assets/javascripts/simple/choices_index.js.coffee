SimplePollVoting =
  init: ->
    $('body').on 'click', '.simple-choice .poll-field', @toggleVoter
    $('.text-choice').on 'click', @toggleSelected
    $('.submit-simple-event-votes').click @submitEventVotes
    setInterval @updateVotedStatus, 500
    @initDateVoter()

  updateVotedStatus: ->
    $('.simple-choice').each ->
      if $(@).find('.selected, .active').length > 0
        $(@).find('.question-name').addClass('voted')
      else
        $(@).find('.question-name').removeClass('voted')

   submitEventVotes: ->
   	values = ""
   	$('.date-voter').each ->
      dates = $(@).datepicker('getDates')
      dates_with_questions = []
      question = $(@).parent().attr('data-question')
      $.each dates, (i,v) ->
        dates_with_questions.push(v + "<question>#{question}")  
      values += dates_with_questions
      values = values.replace(/,/g, "<separator>")
   	$('.text-choice.selected .text-choice-input').each ->
      question = $(@).parents('.text-choice').attr('data-question')
      values += "<separator>" + $(@).text() + "<question>#{question}"
   	console.log values
    values = values.replace(/,/g, "<separator>")
   	$('#choice_values').val("")
   	$('#choice_values').val values
   	$('#simple-events-vote-form').submit()
   	

   initDateVoter: ->
   		$('.submit-simple-event-votes').show()
   		$('.simple-choice').each ->
        dates = $(@).find('.choice-dates').text().split("<separator>")
        parsedDates = $.map dates, (val, i) ->
          new Date val
        dateVoter = $(@).find('.date-voter')
        if dateVoter.length > 0
          dateVoter.datepicker
            'multidate': true
            'beforeShowDay': (date) ->
              shouldShow = false
              for parsedDate in parsedDates
                if parsedDate - date == 0
                  shouldShow = true
              shouldShow
          if $('.selected-choice-dates').text() != ""
            parsedSelectedDates = $.map $('.selected-choice-dates').text().split("<separator>"), (val, i) ->
              new Date val
            dateVoter.datepicker "setDates", parsedSelectedDates
        
        $('.dow').parent().addClass('dow-row')

  toggleVoter: ->
    voter = $(@).parent().find('.simple-voter')
    wasVisible = voter.is(":visible")
  
    # $('.simple-voter').hide()
    if wasVisible
      voter.hide()
      $(@).attr('style',"")
    else
      voter.show() 
      $(@).css('border', 'none')

    if $('.day:visible').length > 0
      console.log "see date"
      console.log $('.day:not(.disabled):visible')
      while $('.day:not(.disabled):visible').length < 1
        $('th.next:visible').first().click()
        console.log "clicking"

    

  toggleSelected: ->
    $(@).toggleClass('selected')
          
ready = ->
  SimplePollVoting.init()
$(document).ready ready
$(document).on 'page:load', ready
