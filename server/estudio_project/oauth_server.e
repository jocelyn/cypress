note
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	OAUTH_SERVER

inherit
	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end
create
	make_and_launch 		--method from WSF_LAUNCHABLE_SERVICE that itself call initialize

feature {NONE} -- Initialization


	initialize
			-- Initialize current service.
		do
			Precursor
			set_service_option ("port", port_number)
			--initialize_router
		end

	launch (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER
		do
			create {WSF_DEFAULT_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			restour: STRING_32
			str:STRING
			n :INTEGER
			parseQ :HASH_TABLE [STRING, STRING]
		do
			print("Request%N")

			across req.query_parameters as wsf_val loop
				print(wsf_val.item.key.out)
			end
		end

	port_number: INTEGER = 5656
end


