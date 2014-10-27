note
	description: "Summary description for {DB_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--Singleton patern to access the the unique Data Base for the server
class
	DB_ACCESS

feature {NONE} -- Access

	db: DB_MANAGER
	local
		once
			create Result.init
		end
end

