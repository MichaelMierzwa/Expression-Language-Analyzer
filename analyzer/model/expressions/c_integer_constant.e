note
	description: "An integer constant expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_INTEGER_CONSTANT

inherit
	D_INTEGER_EXPRESSION
		redefine
			is_equal
		end
create
	make

feature {NONE} -- Constructor
	make (i : INTEGER_64)
		-- Initialize a integer constant expression
		do
			set_val(i)
		ensure
			Initialized: val = i
		end

feature {C_BUILDER}
	build (b : C_BUILDER)
		-- Build on this expression
		do
			b.c_constant (current)
		end

feature {D_VISITOR}
	accept (v : D_VISITOR)
		-- Accept a visitor
		do
			v.c_integer_constant (current)
		end

feature -- Equality
	is_equal (other: like current) : BOOLEAN
		do
			if current.get_val = other.get_val then
				result := true
			else
				result := false
			end
		ensure then
			correct_result: result = (current.get_val = other.get_val)
		end
end
