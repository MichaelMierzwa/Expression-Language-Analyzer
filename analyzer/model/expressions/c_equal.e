note
	description: "An equals operator expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_EQUAL

inherit
	D_BOOLEAN_BINARY_OP
		redefine
			make
		end

create
	make

feature {NONE} -- Constructor
	make
		-- Initialize an equal operator
		do
			precursor
			create op.make_from_string ("=")
		ensure then
			initialized: current.get_op ~ "="
		end

feature {C_BUILDER} -- Builder implementation
	build (b : C_BUILDER)
		-- Build on this operator
		do
			b.d_binary_op (current)
		end

feature {D_VISITOR} -- Visitor implementation
	accept (v : D_VISITOR)
		-- Accept a visitor
		do
			v.c_equal (current)
		end
end
