Home =
  init: ->
    $(window).scroll @fadeElements
    @height = $(window).height()

  fadeElements: ->
    currentHeight = $(window).scrollTop()
    if currentHeight > (Home.height - 80)
      $('.header-link').css('color', '#414141')
      $('#landing-logo').hide()
    else
      $('.header-link').attr('style', '')
      $('#landing-logo').attr('style', '')

ready = ->
  Home.init() if $('#landing-header').length > 0

$(document).ready ready
$(document).on 'page:load', ready
