note
	description: "An open set expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_OPEN_SET -- not used

inherit
	D_EXPRESSION
		redefine
			out
		end

create
	make

feature {NONE} -- Constructor
	make
		-- Initialize a open set expression
		do
			out := "{"
		ensure
			Initialized: current.out ~ "{"
		end

feature -- Queries
	out : STRING

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
		end
end
