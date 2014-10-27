note
	description: "Represent the information about a client"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_CREDENTIALS

inherit

	REFACTORING_HELPER

feature -- Access

	client_id: STRING

	client_secret: STRING
		-- find what it is used for.

	scopes: LIST [STRING]
		-- list of feature that the Client offer

	app_name: STRING

	redir_uri: STRING
		-- the url redirection page where the end user should the rederect once he has sucessfully login.

	description: STRING
		-- optional : a description about the Application.

feature -- Element Change

	set_name (name: STRING)
		do
			app_name := name
		end

	set_client_id (client_id_: STRING)
		do
			client_id := client_id_
		end

	set_redir_uri (red_uri: STRING)
		do
			redir_uri := red_uri
		end

	add_scope (scope: STRING)
		do
			scopes.extend (scope)
		end

	set_scopes (scopes_: LIST [STRING])
		do
			scopes := scopes_
		end

feature -- Status Report

	get_client_id: STRING
		do
			Result := client_id
		end

	is_complete: BOOLEAN
		do
			Result := is_void_safe and is_uri_redir_correct --add more test

		end

	get_error_msg: STRING
			--Maybe use JSON to transmit the error message if time
		do
			create Result.make_empty
			if not is_void_safe then
				Result.append_string ("one or more of the requierd field is Void")
			end
			if not is_uri_redir_correct then
				Result.append_string ("the redirection uri is not correct")
			end

			to_implement ("Add error handling.")

				-- add more error
		end

feature {NONE} -- Implementation

	is_void_safe: BOOLEAN
		do
			Result := client_id /= Void and app_name /= Void and redir_uri /= Void
		end

	is_uri_redir_correct: BOOLEAN
		do
			print ("Redir:" + redir_uri + ":end")
			Result := redir_uri.starts_with ("http%%3A%%2F%%2F") or redir_uri.starts_with ("https%%3A%%2F%%2F") --represente http:// and https://
		end

end
