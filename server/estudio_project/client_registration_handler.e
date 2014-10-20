note
	description: "Summary description for {CLIENT_REGISTRATION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_REGISTRATION_HANDLER

inherit

	WSF_URI_TEMPLATE_HANDLER

feature {NONE}

	formHandler:STRING = "postResponse"

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
		do
			res.set_status_code (200)
			res.header.add_content_type_with_charset ("text/html", "utf-8")

			if attached {WSF_STRING}req.path_parameter ("id") as p_id then
				print(p_id.url_encoded_value)
				if p_id.url_encoded_value.is_equal (formHandler) then				--use Switch
					res.put_string ("Code is : ...")
				else
					res.put_string ("Please register your app")
					res.put_string (gen_html_post)
					print(p_id.url_encoded_value)
				end
			else
				--error
			end
		end

	gen_html_post: STRING
		do
			Result := ("<form name=%"input%" action=%"/ClientRegistration/"+formHandler+"%" method=%"get%">")
			Result.append_string ("App name: <input type=%"text%" name=%"appname%">")
			Result.append_string ("<input type=%"submit%" value=%"Submit%">")
			Result.append_string ("</form>")
		end

end
