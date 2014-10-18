Profile = 
  init: ->
    $('.read-more').click @showMore
    $('.hide-text').click @hideText
    $('.see-more').click @addRow
    $('.see-less').click @removeRow

  addRow: ->
  	$(@).css 'opacity', '0'
  	$(@).parent().find('.hidden-image-row').show().animate 
  		height: "60px"
  	, 250
  	
  	$(@).parent().find('.hidden-image-row').show().animate 
  		opacity: '1'
  	, 500

  removeRow: ->
  	$(@).parent().animate 
  		height: '0px'
  		opacity: '1'
  	, 250, ->
  		$(@).hide().attr('style', '')
  		$('.see-more').css 'opacity', '1'

  showMore: ->
    $(@).hide()
    $(@).parent().find('.more-text').show().addClass('animated fadeIn')

  hideText: ->
    $(@).parent().hide().parent().find('.read-more').show()

ready = ->
  Profile.init()
$(document).ready ready
$(document).on 'page:load', ready