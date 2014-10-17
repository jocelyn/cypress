note
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	OAUTH_SERVER

inherit
	WGI_SERVICE

create
	make

feature {NONE} -- Initialization

	make
			-- create a Nino service
		do
			(create {NINO_SERVICE}.make_custom (Current, "")).listen (port_number)
		end

	execute (req: WGI_REQUEST; res: WGI_RESPONSE)
		local
			restour: STRING_32
			str:STRING
			n :INTEGER
			parseQ :HASH_TABLE [STRING, STRING]
		do
			print("Request%N")
			str := req.query_string
			parseQ := parseQuery(str)
			res.set_status_code (200, Void)
			res.put_header_text ("Content-Type: text/plain%R%N")
			if attached parseQ["test"] as test then
				print("printing value of test%N")
				res.put_string (test)
			end
		end

	parseQuery(query:STRING):HASH_TABLE [STRING, STRING]
		local
		list:LIST[STRING]
		ic:ITERATION_CURSOR[STRING]
		do
			if attached query as str then
				create Result.make (5)
				across str.split ('&') as ics loop
					list:=ics.item.split('=')
					--print(list.first)
					Result[list.first] := list.last
				end
			end

			--Result["test"] := list[0]
		end

	port_number :INTEGER = 6767
end


