note
	description: "Summary description for {DB_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DB_MANAGER

create
	init
feature{DB_ACCESS}

	client_cred_map:HASH_TABLE[CLIENT_CREDENTIALS,STRING]

	init
	do
			--initialize the data base from a file
			--init with a size of 10 client
			create client_cred_map.make (10)
	end

	isClientRegister(client_id:STRING):BOOLEAN
	do

	end

	registerClient(client_cred:CLIENT_CREDENTIALS):STRING
	--return Void in case that the client is allready register otherwise return the client_id
	local
		client_id:STRING
	do
		client_id := client_cred.get_client_id
		if client_cred_map.has_key (client_id) then
			Result := Void
		else
			client_cred_map.put (client_cred, client_id)
			Result := client_id
		end

	end



	findClientCredentials(client_id:STRING):CLIENT_CREDENTIALS
	--return Void in case no client found
	do
		Result := Void
	end


end
