note
	description: "A close set expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_CLOSE_SET

inherit
	D_EXPRESSION
		redefine
			out
		end

create
	make

feature {NONE} -- Constructor
	make
		-- Initialize a close set expression
		once

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
		end

feature -- Queries
	out : STRING
		-- Get close set expression as string
		do
			create result.make_from_string("}")
		ensure then
			result ~ "}"
		end
end
