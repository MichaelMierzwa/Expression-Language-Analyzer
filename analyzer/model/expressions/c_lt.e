note
	description: "A less than operator expression."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	C_LT

inherit
	D_BOOLEAN_BINARY_OP
		redefine
			make
		end

create
	make

feature {NONE} -- Constructor
	make
		-- Initialize a less than operator
		do
			precursor
			create op.make_from_string ("<")
		ensure then
			Initialized: current.get_op ~ "<"
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
			v.c_lt (current)
		end
end
