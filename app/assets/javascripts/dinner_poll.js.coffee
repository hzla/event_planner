DinnerPoll =
  init: ->
    @cycleImages()

  cycleImages: ->
    for i in [0..99999]
      window.clearInterval(i)
    setInterval ->
      current = $('#sec-3 .sec-pic.active')
      next = current.next()
      current.removeClass('active')
      next.addClass('active')
    
      curText = $('#sec-3 .poll-text.active')
      nextText = curText.next()
      curText.removeClass('active')
      nextText.addClass('active')

      if next.hasClass('recycle')
        $('#sec-3 .sec-pic.active').removeClass('active')
        $('#sec-3 .first').addClass('active')

    , 2000



ready = ->
  DinnerPoll.init()
$(document).ready ready
$(document).on 'page:load', ready
