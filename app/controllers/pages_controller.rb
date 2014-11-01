class PagesController < ApplicationController
	skip_before_action :require_login

	def home
		redirect_to dashboard_path if current_user
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