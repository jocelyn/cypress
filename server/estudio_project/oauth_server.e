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
	WSF_ROUTED_SERVICE
	OAUTH_LOGGER
create
	make_and_launch 		--method from WSF_LAUNCHABLE_SERVICE that itself call initialize

feature {NONE} -- Initialization


	initialize
			-- Initialize current service.
		do
			Precursor
			set_service_option ("port", port_number)
			initialize_router
		end

	setup_router
		local

		do

			-- Request Test, with on paramater "id", such as /test/foo and /test/bar
			router.map ( create {WSF_URI_TEMPLATE_MAPPING}.make ("/Authentification", create {AUTH_HANDLER}))
			router.handle_with_request_methods("test",create {CLIENT_REGISTRATION_HANDLER},router.methods_get)
			router.map ( create {WSF_URI_TEMPLATE_MAPPING}.make ("/OAuth/ClientRegistration", create {CLIENT_REGISTRATION_HANDLER}))

			--map_uri_template_agent_with_request_methods("tets",agent client_reg_handler.execute,router.Methods_get)
			--router.map_with_request_methods (a_mapping: WSF_ROUTER_MAPPING, rqst_methods: detachable WSF_REQUEST_METHODS)
		end

	launch (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER
		do
			log.write_information ("OAUTH SERVER LAUNCHED")
			create {WSF_DEFAULT_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)

		end

	port_number: INTEGER = 5656
end


