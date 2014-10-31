Poll =
  init: ->
    $('body').on 'click', '#add-email-btn', @addEmail
    $('body').on 'click', '.submit-emails', @submitEmails
    $('body').on 'click', '.yes-action', @acceptChoice
    $('body').on 'click', '.no-action', @declineChoice
    $('.choice').first().show()

  declineChoice: ->
    btn = $(@)
    $('.choice:visible').addClass('animated zoomOutLeft').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      $(@).hide()
      btn.parents('.choice').next().show()
      Poll.incrementChoiceCounter() if btn.parents('.choice').next().attr('id') != "poll-finished"

  acceptChoice: ->
    btn = $(@)
    $('.choice:visible').addClass('animated zoomOutRight').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      $(@).hide()
      btn.parents('.choice').next().show()
      Poll.incrementChoiceCounter() if btn.parents('.choice').next().attr('id') != "poll-finished"

  incrementChoiceCounter: ->
    $('#choice-counter').text(parseInt($('#choice-counter').text()) + 1)


  addEmail: ->
    email = $('#invite-email').val()
    $('.invitees').append "<div class='invitee'>#{email}</div>"
    $('#invite-email').val ''
    $('.placeholder-invitee').remove()

    currentEmailList = $('#email-list').val()
    newEmailList =  currentEmailList + "#{email}, "
    $('#email-list').val newEmailList 

  submitEmails: ->
    $('#emails-form').submit()



  
    


ready = ->
  Poll.init()
$(document).ready ready
$(document).on 'page:load', ready
