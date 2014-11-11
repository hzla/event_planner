module ApplicationHelper
	def to_hash model
		model_id = model.id
		model = model.as_json
		model.each do |k,v|
			model.delete(k) if v == nil
			if v.class == Fixnum
				model[k] = v.to_s
			end
		end
		model.delete("id")
		model["record_id"] = model_id
		model
	end

	def to_array_of_hashes collection
		p collection
		converted_collection = collection.map do |model|
			to_hash(model)
		end
		converted_collection
	end

	def api_response request_name, result
		{request_name: request_name, status: {code: "200", message: "OK"}, result: result }
	end

	def extract_non_model_attributes params, class_name, include_id=false
		attrs = class_name.column_names
		if include_id && params["record_id"]
			params["id"] = params["record_id"]
		else
		end
		params.each do |k,v|
			params.delete(k) if !attrs.include?(k)
		end
	end

	def api_error request_name, code, message
		{request_name: request_name, status: {code: code, message: message}}
	end

end
