note
	description: "A set expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_SET

inherit
	D_SET_EXPRESSION
	redefine
		is_equal
	end


create
	make

feature {C_BUILDER} -- Builder implementation
	build (b : C_BUILDER)
		-- Build on this expression
		do
			b.c_set (current)
		end

feature {D_VISITOR} -- Visitor implementation
	accept (v : D_VISITOR)
		-- Accept a visitor
		do
			v.c_set (current)
		end

feature -- Equality
	is_equal (other : like current) : BOOLEAN
		-- Is current equal to other?
		do
			result := current.get_area ~ other.get_area
		ensure then
			correct_result: result = (current.get_area ~ other.get_area)
		end
end
