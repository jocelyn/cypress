note
	description: "Summary description for {OAUTH_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OAUTH_LOGGER

feature {NONE} -- Access

	log: LOG_LOGGING_FACILITY
		local
			filename: PATH
			lw_file: LOG_WRITER_FILE
		once ("PROCESS")
			create Result.make
			log.enable_default_file_log
			log.default_log_writer_file.enable_debug_log_level
			create filename.make_from_string ("OAuthServer.log")
			create lw_file.make_at_location (filename)
			lw_file.enable_debug_log_level
			log.register_log_writer (lw_file)
		end

end
