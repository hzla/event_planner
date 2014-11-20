Browse =
  init: ->
    $('body').on 'click', '.option', @toggleOptionSelect
    $('body').on 'click touchend', '.chosen.service-tab', @showChosenOptions
    $('body').on 'click touchend', '.browse.service-tab', @showAllOptions
    $('body').on 'click touchend', '.service-tab', @toggleActive
    $('body').on 'click touchend', '.submit-options', @submitOptions
    $('body').on 'click', '.movie', @toggleMovieSelect
    $('body').on 'ajax:success', '#service-search-form', @showResults
    $('body').on 'keyup', '#service-search-name', @filterResults

  filterResults: ->
    term = $(@).val()
    reg = new RegExp(term, "i")
    $('.option').each (i) ->
      title = $(@).find('.option-title').text()
      if reg.exec(title) != null
        $(@).show()
      else
        $(@).hide()

  showResults: (event, data) ->
    $('.service-options').html data

  toggleMovieSelect: ->
    $(@).toggleClass 'selected' 

  toggleOptionSelect: ->
    id = $(@).attr('id')
    $(".#{id}").toggleClass 'selected'
    Browse.checkDone()
    
    if $(@).hasClass('selected')
      clone = $(@).clone()
      clone.appendTo('.selected-options')
      Browse.addOptionToForm $(@)
    else
      id = $(@).attr('id')
      $('.selected-options').find(".#{id}").remove()
      Browse.removeOptionFromForm $(@)

  addOptionToForm: (option) ->
    image = option.find('img').attr('src')
    title = option.find('.option-title').text()
    info = option.find('.option-info').text()
    id = option.find('.option-id').text()
    console.log id
    $('#image-url-list').val($('#image-url-list').val() + "#{image}<OPTION>")
    $('#title-list').val($('#title-list').val() + "#{title}<OPTION>")
    $('#info-list').val($('#info-list').val() + "#{info}<OPTION>")
    $('#id-list').val($('#id-list').val() + "#{id}<OPTION>")

  removeOptionFromForm: (option) ->
    image = option.find('img').attr('src')
    title = option.find('.option-title').text()
    info = option.find('.option-info').text()
    id = option.find('.option-id').text()
    $('#image-url-list').val($('#image-url-list').val().replace("#{image}<OPTION>", ""))
    $('#title-list').val($('#title-list').val().replace("#{title}<OPTION>", ""))
    $('#info-list').val($('#info-list').val().replace("#{info}<OPTION>", ""))
    $('#id-list').val($('#id-list').val().replace("#{id}<OPTION>", ""))

  checkDone: ->
  	if $('.option.selected').length > 0
  		$('#header-right-pic.done').show()
  	else
  		$('#header-right-pic.done').hide()

  showChosenOptions: ->
  	$('.service-options').hide()
  	$('.selected-options').show()

  showAllOptions: ->
    $('.service-options').show()
    $('.selected-options').hide()


  toggleActive: ->
  	$('.service-tab').removeClass('active')
  	$(@).addClass('active')

  submitOptions: ->
    $('#options-form').submit()




    


ready = ->
  Browse.init()
$(document).ready ready
$(document).on 'page:load', ready
