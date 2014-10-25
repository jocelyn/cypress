note
	description: "Summary description for {CLIENT_REGISTRATION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_REGISTRATION_HANDLER

inherit

	WSF_URI_TEMPLATE_HANDLER

	OAUTH_LOGGER
	DB_ACCESS
feature {OAUTH_SERVER}

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			formHandler:STRING
			client_cred:CLIENT_CREDENTIALS
			scopes:LIST[STRING]
		do
			log.write_information("new Request for a Client registration")
			res.set_status_code (200)
			res.header.add_content_type_with_charset ("text/html", "utf-8")

			if req.request_method.is_equal ("GET") then
				res.put_string (gen_html_post)
			end

			if req.request_method.is_equal("POST") then
				create client_cred

				client_cred.set_name (req.form_parameter (FORM_APPNAME).as_string.url_encoded_value)
				client_cred.set_client_id (req.form_parameter (FORM_CLIENT_ID).as_string.url_encoded_value)
				client_cred.set_redir_uri (req.form_parameter (FORM_REDIRECTION_URI).as_string.url_encoded_value)

				client_cred.set_scopes((req.form_parameter (FORM_SCOPES).as_string.url_encoded_value.as_string_8.split (' ')))

				if client_cred.is_complete then
					if db.registerClient(client_cred) = Void then
						log.write_alert ("The client was already registered")
						res.put_string ("The client was already registered")
					end
				else
					res.put_string (client_cred.get_error_msg)
				end

				--check if there is other way to have POST info
				print("Form : "+req.form_parameter ("appname").as_string.url_encoded_value)
				res.put_string (""+req.item ("appname").as_string.url_encoded_value)

			end


		end
feature {NONE}

	FORM_APPNAME:STRING = "appname"
	FORM_CLIENT_ID:STRING = "client_id"
	FORM_REDIRECTION_URI:STRING = "red_uri"
	FORM_SCOPES:STRING = "scopes"

	gen_html_post: STRING
		do

			Result := ("<form name=%"input%" action=%"ClientRegistration%" method=%"POST%">"
				+"App name: <input type=%"text%" name=%""+FORM_APPNAME+"%"><br>"
				+"Client_id: <input type=%"text%" name=%""+FORM_CLIENT_ID+"%"><br>"
				+"Scopes: <input type=%"text%" name=%""+FORM_SCOPES+"%"><br>"
				+"Rediredction URI: <input type=%"text%" name=%""+FORM_REDIRECTION_URI+"%"><br>"
				+"<input type=%"submit%" value=%"Submit%">"
				+"</form>")

		end

end
