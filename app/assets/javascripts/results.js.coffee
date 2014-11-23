Results =
  init: ->
    $('body').on 'click', '#see-more-results', @seeMoreResults

  seeMoreResults: ->
    $('#more-results').show()
    $(@).hide()

ready = ->
  Results.init()

$(document).ready ready
$(document).on 'page:load', ready
