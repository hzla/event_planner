Home = 
  init: ->
    $('#log-in').click @showLogInForm
    $('#sign-up').click @showSignUpForm
    $('.back-icon').click @goBack
    $('.user-field').blur @checkForm
    @detectMobile()
    @initMobile()

  initMobile: -> #will change if necessary
    if $('.main-logo.text').length > 0 && Home.mobile
      $('.main-logo').hide()
      $('.main-logo.text').show()
    else
      $('.main-logo.text').hide()

  goBack: ->
    location.reload()

  detectMobile: ->
    Home.mobile = $('.mobile:visible').length > 0

  showLogInForm: ->
    $('.form-actions').removeClass 'active'
    $(@).addClass 'active'
    $('#name, #phone_number').css 'border-bottom', 'none'
    $('#name, #phone_number').animate 
    	height: '0px'
    	opacity: 0;
    , 250, ->
    	$(@).hide()
    Home.handleMobileLogin() if Home.mobile

  handleMobileLogin: ->
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
    Home.handleMobileSignUp() if Home.mobile
      
  handleMobileSignUp: ->
    $('.main-logo').hide()
    $('header .mobile, form').show()
    $('#content-container, #sign-up-box').css('background', 'white')
    $('.landing-text, #facebook, .form-actions, #submit-user').hide()

  checkForm: ->
    if $('#sign-up.active').length > 0
      Home.showCheck $('#name') if $('#name').val() != ""
      Home.showCheck $('#password') if $('#password').val() != "" && $('#password').val().length > 6
      Home.showCheck $('#email') if /.+\@.+\..+/.exec $('#email').val()
      Home.showCheck $('#phone_number') if /^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$/.exec $('#phone_number').val()


  showCheck: (field) ->
    field.parent().children('.check-icon').show()

ready = ->
  Home.init()
$(document).ready ready
$(document).on 'page:load', ready