note
	description: "Represent the information about a client"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CLIENT_CREDENTIALS

inherit
	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_client_id: STRING)
			-- Create current credentials for client identified by `a_client_id'.
		do
				-- Initialize
			create {ARRAYED_LIST [STRING]} scopes.make (0)
			client_id := a_client_id
		end

feature -- Access

	client_id: STRING
			-- identifier associated with client.

	client_secret: detachable STRING
			-- find what it is used for.

	scopes: ARRAYED_LIST [STRING]
			-- list of feature that the Client offer

	app_name: detachable STRING
			-- Application name.

	redirection_uri: detachable STRING
			-- the url redirection page where the end user should the rederect once he has sucessfully login.

	description: detachable STRING
			-- optional : a description about the Application.

feature -- Element Change

	set_client_id (a_client_id: STRING)
			-- Set `client_id' to `a_client_id'.
		require
			not_blank: not a_client_id.is_whitespace
		do
			client_id := a_client_id
		end

	set_app_name (a_name: like app_name)
			-- Set `app_name' to `a_name'.
		do
			app_name := a_name
		end

	set_redirection_uri (a_redir_uri: STRING)
			-- Set `redirection_uri' to `a_redir_uri'.
		do
			redirection_uri := a_redir_uri
		end

	add_scope (a_scope: STRING)
			-- Add scope `a_scope'.
		do
			scopes.extend (a_scope)
		end

	set_scopes (a_scopes: LIST [STRING])
			-- Set scopes from `a_scopes'.
		do
			scopes.wipe_out
			across
				a_scopes as ic
			loop
				add_scope (ic.item)
			end
		end

feature -- Status Report

	is_complete: BOOLEAN
		do
			Result := has_required_fields and is_uri_redir_correct --add more test
		end

	error_message: STRING
			-- Maybe use JSON to transmit the error message if time
		do
			create Result.make_empty
			if not has_required_fields then
				Result.append_string ("missing a required fields")
			end
			if not is_uri_redir_correct then
				Result.append_string ("the redirection uri is not correct")
			end
			to_implement ("Add error handling.")

				-- add more error
		end

feature {NONE} -- Implementation

	has_required_fields: BOOLEAN
		do
			Result := 	attached client_id as l_id and then not l_id.is_whitespace and
						attached app_name as l_name and then not l_name.is_whitespace and
						attached redirection_uri as l_uri and then not l_uri.is_whitespace
		end

	is_uri_redir_correct: BOOLEAN
		do
			debug ("oauth")
				if attached redirection_uri as l_uri then
					print ("Redir:" + l_uri + ":end")
				else
					print ("Redir:none:end")
				end
			end
			Result := attached redirection_uri as l_uri and then
						(l_uri.starts_with ("http%%3A%%2F%%2F")
							or l_uri.starts_with ("https%%3A%%2F%%2F")
						) --represents http:// and https://
		end

end
