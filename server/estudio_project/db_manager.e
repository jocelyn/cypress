note
	description: "Summary description for {DB_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DB_MANAGER

inherit

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
		do
				--initialize the data base from a file
				--init with a size of 10 client
			create client_cred_map.make (10)
		end

feature {DB_ACCESS} -- Access

	client_cred_map: STRING_TABLE [CLIENT_CREDENTIALS]

feature {DB_ACCESS} -- Status report		

	is_client_registered (client_id: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := client_cred_map.has (client_id)
		end

feature {DB_ACCESS} -- Access		

	client_credentials (client_id: READABLE_STRING_GENERAL): detachable CLIENT_CREDENTIALS
			-- Client credentials client found, otherwise Void.
		do
			Result := client_cred_map.item (client_id)
		ensure
			is_client_registered (client_id) implies Result /= Void
		end

feature {DB_ACCESS} -- Element change		

	register_client (client_cred: CLIENT_CREDENTIALS)
			-- return Void in case that the client is allready register otherwise return the client_id
		require
			not_registered: not is_client_registered (client_cred.client_id)
		local
			client_id: STRING
		do
			client_id := client_cred.client_id
			if is_client_registered (client_id) then
				check not_registered: False end
			else
				client_cred_map.put (client_cred, client_id)
			end
		ensure
			registered: not is_client_registered (client_cred.client_id)
		end

end
