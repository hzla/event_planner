Home =
  init: ->
    $(window).scroll @fadeElements
    @height = $(window).height()
    $('.phone-info-item').click @showActive

  showActive: ->
    $('.active').removeClass('active')
    $(@).addClass('active')

  fadeElements: ->
    currentHeight = $(window).scrollTop()
    if currentHeight > (Home.height - 80)
      $('.header-link').css('color', 'black')
    else
      $('.header-link').css('color', 'white')



ready = ->
  Home.init() if $('#landing-header').length > 0
$(document).ready ready
$(document).on 'page:load', ready



