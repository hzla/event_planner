UserEdit =
  init: ->
    $('body').on 'click', '.setting-icon', @selectIcon
    $('body').on 'submit', '.edit_user', @addSettingsToForm

  addSettingsToForm: ->
  	if $('#on-vote .yes').hasClass('selected')
  		$('#user_mail_on_vote').val("t")
  	else
  		$('#user_mail_on_vote').val("f")

  	if $('#on-res-success .yes').hasClass('selected')
  		$('#user_mail_on_res_success').val("t")
  	else
  		$('#user_mail_on_res_success').val("f")

  	if $('#on-res-failure .yes').hasClass('selected')
  		$('#user_mail_on_res_failure').val("t")
  	else
  		$('#user_mail_on_res_failure').val("f")

  	if $('#on-res-24-hour .yes').hasClass('selected')
  		$('#user_mail_on_res_24_hour').val("t")
  	else
  		$('#user_mail_on_res_24_hour').val("f")

  	$('#save-settings').val("Saved!")
  	setTimeout ->
  		$('#save-settings').val("Save")
  	, 2000

  selectIcon: ->
  	field = $(@).parents('.poll-field')
  	field.find('.svg-container').removeClass("selected")
  	$(@).parents('.svg-container').addClass('selected')



ready = ->
  UserEdit.init()

$(document).ready ready
$(document).on 'page:load', ready
