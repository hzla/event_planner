Profile = 
  init: ->
    $('.read-more').click @showMore
    $('.hide-text').click @hideText
    $('.see-more').click @addRow
    $('.see-less').click @removeRow

  addRow: ->
  	$(@).css 'opacity', '0'
  	$(@).parent().find('.hidden-image-row').show()

  removeRow: ->
  	$('.see-more').css 'opacity', '1'
  	$(@).parent().hide()

  showMore: ->
    $(@).hide()
    $(@).parent().find('.more-text').show()

  hideText: ->
    $(@).parent().hide().parent().find('.read-more').show()

ready = ->
  Profile.init()
$(document).ready ready
$(document).on 'page:load', ready