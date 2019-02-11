note
	description: "A dummy expression for expression that have not been fully specified"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_DUMMY

inherit
	D_EXPRESSION

create
	make

feature {NONE} -- Constructor
	make
		-- Initialize a dummy expression
		do

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
			v.c_dummy (current)
		end
end
