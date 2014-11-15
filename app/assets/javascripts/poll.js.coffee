Poll =
  init: ->
    $('body').on 'click', '#add-email-btn', @addEmail
    $('body').on 'touchend click', '.submit-emails', @submitEmails
    $('body').on 'ajax:success', '.upvote-link, .downvote-link', @choose
    $('body').on 'click', '#finish-poll-take', @showPollFinished
    $('body').on 'click', '#finish-tutorial', @finishTutorial
    $('.choice').first().show()
    @showNext() if $('.invitees .invitee.real').length > 0
    @addEmails()
    @centerProfile()

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

  addEmails: ->
    invitees = $(".invitee").map ->
      $(@).text()
    .get().join(', ')
    $('#email-list').val invitees

 
  choose: (event, data) ->
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

    console.log data

  addEmail: ->
    email = $('#invite-email').val()
    if email != ''
      $('.invitees').append "<div class='invitee'>#{email}</div>"
      $('#invite-email').val ''
      $('.placeholder-invitee').remove()
      currentEmailList = $('#email-list').val()
      newEmailList =  currentEmailList + ", #{email}"
      $('#email-list').val newEmailList 
      Poll.showNext()

  submitEmails: ->
    $('#emails-form').submit()

  showNext: ->
    $('.submit-emails').first().show() 

    




  
    


ready = ->
  Poll.init()
$(document).ready ready
$(document).on 'page:load', ready
