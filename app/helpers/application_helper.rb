module ApplicationHelper
	def to_hash model
		model = model.as_json
		model.each do |k,v|
			model.delete(k) if v == nil
			if v.class == Fixnum
				model[k] = v.to_s
			end
		end
		model
	end

	def to_array_of_hashes collection
		converted_collection = collection.map do |model|
			to_hash(model)
		end
		converted_collection
	end
end
