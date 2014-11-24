Poll =
  init: ->
    $('body').on 'ajax:success', '.upvote-link, .downvote-link', @choose
    $('body').on 'click', '#finish-poll-take', @showPollFinished
    $('body').on 'click', '#finish-tutorial', @finishTutorial
    $('.choice').first().show()
    @centerProfile()
    @sortChoices()

  finishTutorial: ->
    $('#poll-take-tutorial').hide()

  showPollFinished: ->
    $(@).hide()
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
        $(@).parent().find('g').css('stroke', '#bebebe')
        $(@).find('g').css('stroke', '#00CC99')
        count.css('color', '#00CC99')
        current_score = count.find('.choice-score')
        new_score = parseInt(current_score.text()) + delta
        current_score.text new_score
      else
        $(@).parent().find('g').css('stroke', '#bebebe')
        $(@).find('g').css('stroke', '#FF0043')
        count.css('color', '#FF0043')
        current_score = count.find('.choice-score')
        new_score = parseInt(current_score.text()) - delta
        current_score.text new_score


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
