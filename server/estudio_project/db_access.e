note
	description: "Singleton patern to access the the unique Data Base for the server"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DB_ACCESS

feature {NONE} -- Access

	db: DB_MANAGER
		once
			create Result.make
		end

end
