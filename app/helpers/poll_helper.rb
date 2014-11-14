module PollHelper
	
	def description(poll)
		if poll.event.comment.length > 200
			("#{poll.event.desc[0..199]}<span class='read-more'>... Read More</span>" + 
			"<span class='more-text hidden'>#{poll.event.desc[200..-1]}" + 
			"<span class='hide-text'>Hide</span></span>").html_safe
		else
			poll.event.comment
		end
	end

	def suffixify n
		if n == 1
			"1st"
		elsif n == 2 
			"2nd"
		elsif n == 3
			"3rd"
		else
			"#{n}th"
		end
	end


end
