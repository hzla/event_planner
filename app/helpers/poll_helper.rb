module PollHelper
	
	def description(poll)
		if poll.event.desc.length > 200
			("#{poll.event.desc[0..199]}<span class='read-more'>... Read More</span>" + 
			"<span class='more-text hidden'>#{poll.event.desc[200..-1]}" + 
			"<span class='hide-text'>Hide</span></span>").html_safe
		else
			poll.event.desc
		end
	end


end
