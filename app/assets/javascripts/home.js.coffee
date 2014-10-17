Home = 
  init: ->
    $('#log-in').click @showLogInForm
    $('#sign-up').click @showSignUpForm
    $('.back-icon').click @goBack
    @initMobile()

  initMobile: ->
    if $('.main-logo.text').length > 0
      $('.main-logo').hide()
      $('.main-logo.text').show()

  goBack: ->
    location.reload()


  showLogInForm: ->
    $('.form-actions').removeClass 'active'
    $(@).addClass 'active'
    $('#name, #phone_number').css 'border-bottom', 'none'
    $('#name, #phone_number').animate 
    	height: '0px'
    	opacity: 0;
    , 250, ->
    	$(@).hide()
    if $('.mobile:visible').length > 0
      $('#main-logo, .add-photo').hide()
      $('#header-left, form').show()
      $('#content-container, #sign-up-box').css('background', 'white')
      $('.landing-text, #facebook, .form-actions').hide()


  showSignUpForm: ->
  	$('.form-actions').removeClass 'active'
  	$(@).addClass 'active'
  	$('#name, #phone_number').show()
  	$('#name, #phone_number').animate 
  		height: '40px'
  		opacity: 1;
  	, 250, ->
  		$('#name, #phone_number').css('border-bottom', '1px solid lightgray')
    if $('.mobile:visible').length > 0
      
      $('.main-logo').hide()
      $('header .mobile, form').show()
      $('#content-container, #sign-up-box').css('background', 'white')
      $('.landing-text, #facebook, .form-actions, #submit-user').hide()

  
ready = ->
  Home.init()
$(document).ready ready
$(document).on 'page:load', ready