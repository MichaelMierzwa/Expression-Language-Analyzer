note
	description: "A negation operator expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_NEGATION

inherit
	D_BOOLEAN_UNARY_OP
		redefine
			make
		end

create
	make

feature {NONE} -- Constructor
	make
		-- Initialize a negation operator
		do
			precursor
			create op.make_from_string ("!")
		ensure then
			Initialized: current.get_op ~ "!"
		end

feature {C_BUILDER} -- Builder implementation
	build (b : C_BUILDER)
		-- Build on this operator
		do
			b.d_unary_op (current)
		end

feature {D_VISITOR} -- Visitor implementation
	accept (v : D_VISITOR)
		-- Accept a visitor
		do
			v.c_negation (current)
		end
end
