Profile = 
  init: ->
    $('.read-more').click @showMore
    $('.hide-text').click @hideText
    $('.see-more').click @addRow
    $('.see-less').click @removeRow

  addRow: ->
  	$(@).hide()
  	$(@).parent().find('.pic-container.hidden').css('display', 'inline-block').animate 
  		height: "40px"
  	, 250
  	$(@).parent().find('.pic-container.hidden').css('display', 'inline-block').animate 
  		opacity: '1'
  	, 500, ->
  		$(@).addClass('shown')
  	$('')

  removeRow: ->
  	$('.shown').animate 
  		opacity: '0'
  	, 250, ->
  		$(@).hide().attr('style', '')
  		$('.see-more').show()

  showMore: ->
    $(@).hide()
    $(@).parent().find('.more-text').show().addClass('animated fadeIn')

  hideText: ->
    $(@).parent().hide().parent().find('.read-more').show()

ready = ->
  Profile.init()
$(document).ready ready
$(document).on 'page:load', ready