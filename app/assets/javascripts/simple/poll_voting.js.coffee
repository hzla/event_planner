SimplePollVoting =
  init: ->
    $('body').on 'click', '.simple-choice .poll-field', @toggleVoter
    $('.text-choice').on 'click', @toggleSelected
    $('.submit-simple-event-votes').click @submitEventVotes
    $('.datepicker, .text-choice').click @updateVotedStatus
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
   		values += dates
   		console.log dates
   	$('.text-choice.selected .text-choice-input').each ->
   		values += "<separator>" + $(@).text()
   	console.log values
   	values = values.replace(/,/g, "<separator>")  
   	
   	console.log values
   	$('#choice_values').val("")
   	$('#choice_values').val values
   	$('#simple-events-vote-form').submit()
   	

   initDateVoter: ->
   		$('.submit-simple-event-votes').show()
   		$('.simple-choice').each ->
   			dates = $(@).find('.choice-dates').text().split("<separator>")
   			parsedDates = $.map dates, (val, i) ->
   				new Date val
   			console.log parsedDates
   			dateVoter = $(@).find('.date-voter')
   			dateVoter.datepicker
      		'multidate': true
      		'beforeShowDay': (date) ->
      			shouldShow = false
      			for parsedDate in parsedDates
      				if parsedDate - date == 0
      					shouldShow = true
      				break if shouldShow
      			shouldShow

      	parsedSelectedDates = $.map $('.selected-choice-dates').text().split("<separator>"), (val, i) ->
      		new Date val

      	console.log parsedSelectedDates
      	dateVoter.datepicker "setDates", parsedSelectedDates






    	$('.dow').parent().addClass('dow-row')

  toggleVoter: ->
    $(@).parent().find('.simple-voter').toggle() 

  toggleSelected: ->
    $(@).toggleClass('selected')

          
ready = ->
  SimplePollVoting.init()
$(document).ready ready
$(document).on 'page:load', ready
