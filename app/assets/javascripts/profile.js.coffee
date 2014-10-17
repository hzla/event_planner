Profile = 
  init: ->
    $('.read-more').click @showMore
    $('.hide-text').click @hideText

  showMore: ->
    $(@).hide()
    $(@).parent().find('.more-text').show()

  hideText: ->
    $(@).parent().hide().parent().find('.read-more').show()

ready = ->
  Profile.init()
$(document).ready ready
$(document).on 'page:load', ready