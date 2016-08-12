module TranslationsHelper
	def flatten_hash hash
		hash.each_with_object({}) do |(k, v), h|
			if v.is_a? Hash
				flatten_hash(v).map do |h_k, h_v|
					h["#{k}.#{h_k}"] = h_v
				end
			else 
				h[k] = v
			end
		 end
	end

	def translation_keys
		flatten_hash(YAML.load_file('config/locales/en.yml')["en"]).keys
	end

	def translation_for_key(translations, key)
		hits = translations.to_a.select{ |t| t.key == key }
		hits.first
	end
end