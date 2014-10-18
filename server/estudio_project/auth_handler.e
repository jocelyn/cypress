note
	description: "Summary description for {REQUEST_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUTH_HANDLER

inherit

	WSF_URI_TEMPLATE_HANDLER

feature {NONE}

execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			restour: STRING_32
			str:STRING
			n :INTEGER
			r: WSF_STRING
			parseQ :HASH_TABLE [STRING, STRING]
		do
			res.set_status_code (200)
			res.put_header_text ("Content-Type: text/plain%R%N")
			print("Request%N")
			across req.query_parameters as wsf_val loop
				r:=wsf_val.item.as_string
				print(r.url_encoded_name + "=>" + r.url_encoded_value +"%N")
				res.put_string (r.url_encoded_name + "=>" + r.url_encoded_value +"%N")

			end
		end



end
