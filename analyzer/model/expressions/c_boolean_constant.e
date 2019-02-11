note
	description: "A boolean constant expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_BOOLEAN_CONSTANT

inherit
	D_BOOLEAN_EXPRESSION
	redefine
		is_equal
	end

create
	make

feature {NONE} -- Constructor
	make (b : BOOLEAN)
		-- Initialize a boolean constant
		do
			set_val(b)
		ensure
			initialized: val ~ b
		end

feature {C_BUILDER} -- Builder implementation
	build (b : C_BUILDER)
		-- Build on this expression
		do
			b.c_constant (current)
		end

feature {D_VISITOR} -- Visitor implementation
	accept (v : D_VISITOR)
		-- Accept a visitor
		do
			v.c_boolean_constant (current)
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
