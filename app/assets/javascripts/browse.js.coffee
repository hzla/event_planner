Browse =
  init: ->
    $('body').on 'click', '.option', @toggleOptionSelect
    $('body').on 'click touchend', '.chosen.service-tab', @showChosenOptions
    $('body').on 'click touchend', '.browse.service-tab', @showAllOptions
    $('body').on 'click touchend', '.service-tab', @toggleActive
    $('body').on 'click touchend', '.submit-options', @submitOptions

  toggleOptionSelect: ->
    $(@).toggleClass 'selected'
    Browse.checkDone()
    
    if $(@).hasClass('selected')
      Browse.addOptionToForm $(@)
    else
      Browse.removeOptionFromForm $(@)

  addOptionToForm: (option) ->
    image = option.find('img').attr('src')
    title = option.find('.option-title').text()
    info = option.find('.option-info').text()
    $('#image-url-list').val($('#image-url-list').val() + "#{image}<OPTION>")
    $('#title-list').val($('#title-list').val() + "#{title}<OPTION>")
    $('#info-list').val($('#info-list').val() + "#{info}<OPTION>")

  removeOptionFromForm: (option) ->
    image = option.find('img').attr('src')
    title = option.find('.option-title').text()
    info = option.find('.option-info').text()
    $('#image-url-list').val($('#image-url-list').val().replace("#{image}<OPTION>", ""))
    $('#title-list').val($('#title-list').val().replace("#{title}<OPTION>", ""))
    $('#info-list').val($('#info-list').val().replace("#{info}<OPTION>", ""))

  checkDone: ->
  	if $('.option.selected').length > 0
  		$('#header-right-pic.done').show()
  	else
  		$('#header-right-pic.done').hide()


  showChosenOptions: ->
  	$('.option').hide()
  	$('.option.selected').show()

  showAllOptions: ->
  	$('.option').show()

  toggleActive: ->
  	$('.service-tab').removeClass('active')
  	$(@).addClass('active')

  submitOptions: ->
    $('#options-form').submit()




    


ready = ->
  Browse.init()
$(document).ready ready
$(document).on 'page:load', ready
