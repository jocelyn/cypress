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
			client_cred: detachable CLIENT_CREDENTIALS
			scopes: LIST [STRING]
			msg: WSF_PAGE_RESPONSE
			s: STRING
			utf: UTF_CONVERTER
		do
			log.write_information ("new Request for a Client registration")
			create s.make_empty

			create msg.make
			msg.set_status_code ({HTTP_STATUS_CODE}.ok)
			msg.header.put_content_type_utf_8_text_plain

			if req.is_get_request_method then
				msg.set_body (new_html_post)
				res.send (msg)
			elseif req.is_post_request_method then
					-- FIXME: the code should check for existing and valid form data
				if attached utf8_form_parameter (req, Form_client_id) as l_client_id then
					create client_cred.make (l_client_id)
					if attached utf8_form_parameter (req, Form_appname) as l_appname then
						client_cred.set_app_name (l_appname)
					end
					if attached utf8_form_parameter (req, Form_redirection_uri) as l_redir_uri then
						client_cred.set_redirection_uri (l_redir_uri)
					end
					if attached utf8_form_parameter (req, Form_scopes) as l_scopes then
						client_cred.set_scopes (l_scopes.split (' '))
					end
				end

				if client_cred /= Void then
					if client_cred.is_complete then
						if db.is_client_registered (client_cred.client_id) then
							log.write_alert ("The client was already registered!")
							s.append_string ("The client was already registered!")
						else
							db.register_client (client_cred)
						end
					else
						s.append_string (client_cred.error_message)
					end
				else
					s.append_string ("Missing required client_id!")
				end

					-- check if there is other way to have POST info
				debug ("oauth")
					print ("Form : ")
					if attached utf8_form_parameter (req, "appname") as l_appname then
						print (l_appname)
					end
					print ("%N")
				end
				if attached req.string_item ("appname") as l_appname then
					s.append_string (utf.escaped_utf_32_string_to_utf_8_string_8 (l_appname))
				else
					s.append_string ("missing appname") -- FIXME
				end
				msg.set_body (s)
				res.send (msg)
			else
					-- ... should send something !
				res.send (create {WSF_NOT_IMPLEMENTED_RESPONSE}.make (req))
			end
		end

feature -- Helper

	utf8_form_parameter (req: WSF_REQUEST; a_name: READABLE_STRING_GENERAL): detachable STRING_8
		local
			utf: UTF_CONVERTER
		do
			if attached {WSF_STRING} req.form_parameter (a_name) as l_param then
				Result := utf.string_32_to_utf_8_string_8 (l_param.value)
			end
		end

feature {NONE} -- Constants

	Form_appname: STRING = "appname"

	Form_client_id: STRING = "client_id"

	Form_redirection_uri: STRING = "red_uri"

	Form_scopes: STRING = "scopes"

feature {NONE} -- Implementation	

	new_html_post: STRING
		do
			Result := ("<form name=%"input%" action=%"ClientRegistration%" method=%"POST%">" +
						"App name: <input type=%"text%" name=%"" + form_appname + "%"><br>" +
						"Client_id: <input type=%"text%" name=%"" + form_client_id + "%"><br>" +
						"Scopes: <input type=%"text%" name=%"" + form_scopes + "%"><br>" +
						"Rediredction URI: <input type=%"text%" name=%"" + form_redirection_uri + "%"><br>" +
						"<input type=%"submit%" value=%"Submit%">" + "</form>")
		end

end
