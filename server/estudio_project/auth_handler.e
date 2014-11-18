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
			msg: WSF_PAGE_RESPONSE
			s: STRING
		do
			debug ("oauth")
				print ("Request%N")
			end

				-- Compute the response body message
			create s.make_empty
			across
				req.query_parameters as ic
			loop
				if attached {WSF_STRING} ic.item as w_string then
					debug ("oauth")
						print (w_string.url_encoded_name + "=>" + w_string.url_encoded_value + "%N")
					end
					s.append_string (w_string.url_encoded_name + "=>" + w_string.url_encoded_value + "%N")
				end
			end

				-- Send the message			
			create msg.make
			msg.set_status_code ({HTTP_STATUS_CODE}.ok)
			msg.header.put_content_type_text_plain
			msg.set_body (s)
			res.send (msg)
		end

end
