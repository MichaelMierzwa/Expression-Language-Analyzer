note
	description: "Builds an expression by inserting an expression at a time"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_BUILDER

inherit
	ANY
		redefine
			out
		end

create
	make

feature {NONE} -- Constructor
	make (s : C_START)
		-- Initialize a builder
		do
			start := s
			val := create {C_DUMMY}.make
			create error_fully_specified.make_from_string("Error (Expression is already fully specified).")
			create error_not_being_specified.make_from_string("Error (Set enumeration is not being specified).")
			create error_must_be_non_empty.make_from_string("Error: (Set enumeration must be non-empty).")
			create no_error.make_from_string ("OK.")
			create error.make_from_string(no_error)
		ensure
			attributes_initialized:
				start ~ s and
				val ~ create {C_DUMMY}.make and
				error_fully_specified ~ "Error (Expression is already fully specified)." and
				error_not_being_specified ~ "Error (Set enumeration is not being specified)." and
				error_must_be_non_empty ~ "Error: (Set enumeration must be non-empty)." and
				no_error ~ "OK." and
				error ~ "OK."
		end

feature {NONE}
	start : C_START
	inserted : BOOLEAN
	val : D_EXPRESSION
	error : STRING
	error_fully_specified : STRING
	error_not_being_specified : STRING
	error_must_be_non_empty : STRING
	no_error : STRING

feature -- Queries
	has_error : BOOLEAN
		-- did the builder get an error on last insert
		do
			result := not error.is_empty
		ensure
			correct_result: result /= error.is_empty
		end

	get_error_msg : STRING
		-- get error message if has one
		require
			has_error
		do
			create result.make_from_string (error)
		ensure
			correct_result: result ~ error
		end

	out : STRING
		-- gives state of last insert
		do
			if has_error then
				create result.make_from_string(get_error_msg)
			else
				create result.make_from_string(no_error)
			end
		ensure then
			case_has_error: has_error implies result ~ error
			case_no_error: (not has_error) implies result ~ no_error
		end

feature -- Implementation
	insert (e : D_EXPRESSION)
		-- attempt to insert an expression
		require
			not_dummy_expression: not attached {C_DUMMY} e
		do
			inserted := false
			val := e
			create error.make_empty
			start.build(current)
		end

feature {C_START}
	c_start (h : C_START)
		-- insert into the start of heap
		require
			no_error : not has_error
		do
			if attached {C_DUMMY} h.get_start as s then
				if
					attached {C_CLOSE_SET} val as v
				then
					create error.make_from_string (error_not_being_specified)
				else
					h.change_start(val)
					inserted := true
				end
			else
				h.get_start.build (current)
			end

			if not inserted then
				create error.make_from_string (error_fully_specified)
			end
		ensure
			error_on_full_exp: (not inserted) implies error ~ error_fully_specified
		end

feature {D_EXPRESSION}
	c_constant (h: D_EXPRESSION)
		-- insert into constant
		do
			-- do nothing for constants
		end

feature {C_SET}
	c_set (h : C_SET)
		-- insert into set
		do
			across
				h as s
			loop
				if not inserted then
					s.item.build (current)
				end
			end

			if not inserted then
				if attached {C_CLOSE_SET} val as v then
					if h.is_open then
						if h.is_empty then
							create error.make_from_string (error_must_be_non_empty)
						else
							h.close
							create error.make_empty
						end
						inserted := true
					else
						create error.make_from_string (error_fully_specified)
					end
				elseif h.is_open then
					h.extend (val)
					inserted := true
				end
			end
		end

feature {D_BINARY_OP}
	d_binary_op (h : D_BINARY_OP)
		-- insert into binary operator
		do
			if not inserted then
				if attached {C_DUMMY} h.get_first as f then
					if attached {C_CLOSE_SET} val as v then
						create error.make_from_string (error_not_being_specified)
					else
						h.change_first (val)
					end
					inserted := true
				else
					h.get_first.build (current)
				end
			end

			if not inserted then
				if attached {C_DUMMY} h.get_second as f then
					if attached {C_CLOSE_SET} val as v then
						create error.make_from_string (error_not_being_specified)
					else
						h.change_second (val)
					end
					inserted := true
				else
					h.get_second.build (current)
				end
			end
		end

feature {D_UNARY_OP}
	d_unary_op (h : D_UNARY_OP)
		-- insert into unary operator
		do
			if not inserted then
				if attached {C_DUMMY} h.get_first as f then
					if attached {C_CLOSE_SET} val as v then
						create error.make_from_string (error_not_being_specified)
					else
						h.change_first (val)
					end
					inserted := true
				else
					h.get_first.build (current)
				end
			end
		end
end
