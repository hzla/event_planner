Poll =
  init: ->
    $('body').on 'ajax:success', '.upvote-link, .downvote-link', @choose
    $('body').on 'click', '#finish-poll-take', @showPollFinished
    $('body').on 'click', '#finish-tutorial', @finishTutorial
    $('.choice').first().show()
    @centerProfile()
    @sortChoices()
    @confirmRSVP()
    $('body').on 'click', '.step-arrow.right', @goNextTut
    $('body').on 'click', '.step-arrow.left', @goBackTut

  goNextTut: ->
    current = $('.voter-tut-step.active, .step-dot.active')
    next = current.next()
    current.removeClass('active')
    next.addClass('active')
    $('.step-arrow.left').show()
    if $('.step-dot.active').length < 1
      $('#voter-tutorial-container').hide()

  goBackTut: ->
    current = $('.voter-tut-step.active, .step-dot.active')
    back = current.prev()
    current.removeClass('active')
    back.addClass('active')
    if $('.step-dot.first.active').length > 0
      $('.step-arrow.left').hide()


  confirmRSVP: ->
    if $('.rsvp-btn:visible').length > 0
      $('.vote-link').hide()
      $('.rsvp-btn').click ->
        $('#rsvp-container').hide()
        $('.vote-link').show()

  finishTutorial: ->
    $('#poll-take-tutorial').hide()

  showPollFinished: ->
    $(@).hide()
    $('#lock-event').hide()
    $('#choices').hide()
    $('#poll-finished').show()

  centerProfile: ->
    setTimeout ->
      $('#profile-pic').css 'left', "-#{($('#profile-pic').width()-100)/2}px"
    , 200

  choose: (event, data) ->
    #REFACTOR add css to achieve same effects, only use js to add class
      count = $(@).parent()
      delta = data.delta
      if data.changed
        if data.answer == "yes"
          current_score = count.find('.choice-score')
          new_score = parseInt(current_score.text()) + delta
          current_score.text new_score
          gray = ($(@).parents('.choice-vote-container').find('.downvote-link').find('g').first().css('stroke') == "rgb(255, 0, 67)")
          $(@).parent().find('g').css('stroke', '#bebebe')
          if !gray
            $(@).parent().find('g').css('stroke', '#bebebe')
            $(@).find('g').css('stroke', '#00CC99')
            current_score.css('color', '#00CC99')
          else
            $(@).parent().find('g').css('stroke', '#bebebe')
            $(@).find('g').css('stroke', '#bebebe')
            current_score.css('color', '#bebebe')
        else
          current_score = count.find('.choice-score')
          new_score = parseInt(current_score.text()) - delta
          current_score.text new_score
          current_score.css('color','bebebe')
          gray = ($(@).parents('.choice-vote-container').find('.upvote-link').find('g').first().css('stroke') == "rgb(0, 204, 153)")
          $(@).parent().find('g').css('stroke', '#bebebe')
          if !gray
            $(@).find('g').css('stroke', '#FF0043')
            current_score.css('color', '#FF0043')
          else    
            $(@).parent().find('g').css('stroke', '#bebebe')
            $(@).find('g').css('stroke', '#bebebe')
            current_score.css('color', '#bebebe')


  sortChoices: ->
    sortedChoices = $('.choice').sort (a,b) ->
      aScore = parseInt($(a).find('.choice-score').text())
      bScore = parseInt($(b).find('.choice-score').text())
      if aScore > bScore
        return -1
      else if bScore > aScore
        return 1
      else
        return 0
    sortedChoices.detach().appendTo('#choices')


ready = ->
  Poll.init()

$(document).ready ready
$(document).on 'page:load', ready
