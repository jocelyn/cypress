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

			router.map ( create {WSF_URI_TEMPLATE_MAPPING}.make ("/ClientRegistration/{id}", create {CLIENT_REGISTRATION_HANDLER}))
		end

	launch (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER
		do
			create {WSF_DEFAULT_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

	port_number: INTEGER = 5656
end


