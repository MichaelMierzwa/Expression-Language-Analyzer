note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create root.make
			create builder.make (root)
			create pp.make (root)
			create tc.make (root)
			create ev.make (root)
			s := create {STRING}.make_from_string ("Expression is initialized.")
		end

feature {NONE}-- model attributes
	v : STRING
		do
			result := "Expression currently specified: " + pp.pretty_print
		end
	s : STRING
	builder : C_BUILDER
	pp : C_PRETTY_PRINTING
	tc : C_TYPE_CHECK
	ev : C_EVALUATE
	root : C_START

feature -- model operations
	default_update
		-- Perform update to the model state.
		do
		end

	reset
		-- Reset model state.
		do
			make
		end

	update (cmd : ETF_COMMAND)
		-- Runs command and updates model
		do
			if attached {ETF_RESET} cmd as c then
				if attached {C_DUMMY} root.get_start as start then
					reset
					create s.make_from_string ("Error (Initial expression cannot be reset).")
				else
					reset
					create s.make_from_string ("OK.")
				end

			elseif attached {ETF_EVALUATE} cmd as c then
				tc.typec

				if(tc.error_string ~ "not_full") then
					create s.make_from_string (tc.out)
				elseif(tc.error_string ~ "not_tc") then
					create s.make_from_string ("Error (Expression is not type-correct).")
				else
					ev.evaluate
					if ev.has_error then
						create s.make_from_string (ev.get_error)
					else
						create s.make_from_string (ev.out)
					--	create s.make_from_string (pp.get_str)
					--	s.append (" evaluates to ")
					--	s.append (ev.out)
					end
				end
			elseif attached {ETF_TYPE_CHECK} cmd as c then
				tc.typec

				if(tc.error_string ~ "not_full") then
					create s.make_from_string (tc.out)


				else
					create s.make_from_string(pp.pretty_print)
					s.append (tc.out)
				end
			end
		end

	update_exp (cmd : D_EXPRESSION)
		-- update model by adding expression
		do
			builder.insert (cmd)
			create s.make_from_string (builder.out)
		end


feature -- queries
	out : STRING
		-- outputs the model state and error message if any
		do
			create Result.make_from_string ("  ")
			result.append (v)
			result.append ("%N  Report: ")
			result.append (s)
			--result.append (".")
		end


end




