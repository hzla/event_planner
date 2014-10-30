Poll =
  init: ->
    $('body').on 'click', '#add-email-btn', @addEmail
    $('body').on 'click', '.submit-emails', @submitEmails

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
