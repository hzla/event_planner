Browse =
  init: ->
    $('body').on 'click', '.option', @toggleOptionSelect
    $('body').on 'click', '.chosen.service-tab', @showChosenOptions
    $('body').on 'click', '.browse.service-tab', @showAllOptions
    $('body').on 'click', '.service-tab', @toggleActive

  toggleOptionSelect: ->
    $(@).toggleClass 'selected'
    Browse.checkDone()

  checkDone: ->
  	if $('.option.selected').length > 0
  		$('#header-right-pic.done').show()
  	else
  		$('#header-right-pic.done').hide()



  showChosenOptions: ->
  	$('.option').hide()
  	$('.option.selected').show()

  showAllOptions: ->
  	$('.option').show()

  toggleActive: ->
  	$('.service-tab').removeClass('active')
  	$(@).addClass('active')




    


ready = ->
  Browse.init()
$(document).ready ready
$(document).on 'page:load', ready
