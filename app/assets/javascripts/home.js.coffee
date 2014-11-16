Home =
  init: ->
    $(window).scroll @fadeElements
    @height = $(window).height()
    @doubleHeight = @height * 2
    @tripleHeight = @height * 3
    @halfHeight = ($(window).height() / 2)
    @threeHalfHeight = @halfHeight * 3
    @trigger = false
    $('.phone-info-item').click @showActive

  showActive: ->
    $('.active').removeClass('active')
    $(@).addClass('active')

  fadeElements: ->
    currentHeight = $(window).scrollTop()

    if currentHeight < Home.height + 100 && currentHeight > Home.height - 100
      console.log "tried"
      $(window).scrollTop(Home.height)
    else if currentHeight < Home.doubleHeight + 100 && currentHeight > Home.doubleHeight - 100
      $(window).scrollTop(Home.doubleHeight)
    else if currentHeight < Home.tripleHeight + 300 && currentHeight > Home.tripleHeight - 100
      $(window).scrollTop(Home.tripleHeight)
    else

    if currentHeight < (Home.height * 3) - 5
      if currentHeight < Home.halfHeight
        fade2 = 0
        fade1 = Math.round((1 - (currentHeight / (Home.halfHeight))) * 100) / 100 
      else if currentHeight > Home.halfHeight && currentHeight < Home.threeHalfHeight
        fade2 = Math.round((1 - ((currentHeight - Home.height)  / (Home.height))) * 100) / 100 
        fade1 = 0
        fade3 = 0
      else 
        fade3 = Math.round((1 - ((currentHeight - Home.threeHalfHeight)  / (Home.height * 3 ))) * 100) / 100 
      $('#fade-1').css('opacity', fade1)
      $('#fade-2').css('opacity', fade2)
      $('.fade-3').css('opacity', fade3)
    else
      if Home.trigger == false
        Home.trigger = true
        setTimeout ->
          Home.trigger = false
        , 1000
        Home.showcasePhone()

  showcasePhone: ->
    if $('.phone-info-item.active').length < 1
      $('.phone-info-item').first().addClass('active')
    else
      console.log "done"
      next = $('.active').next()
      $('.active').removeClass('active')
      next.addClass('active')
      if next.length < 1
        $('#get-started-button').show().addClass('animated fadeIn')


ready = ->
  Home.init() if $('#landing-header').length > 0
$(document).ready ready
$(document).on 'page:load', ready



