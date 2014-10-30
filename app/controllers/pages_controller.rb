class PagesController < ApplicationController
	skip_before_action :require_login

	def home
	end

	def screen_one
		@home = false
	end

	def screen_two
		@home = false
	end

	def app_store		
	end

end