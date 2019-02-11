note
	description: "A start expression to denote start of heap"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_START

inherit
	D_EXPRESSION

create
	make

feature {NONE} -- Constructor
	make
		-- Initialize a start expression
		do
			start := create {C_DUMMY}.make
		end

feature {NONE} -- Attributes
	start : D_EXPRESSION

feature
	get_start : D_EXPRESSION
		-- Get starting expression
		do
			result := start
		end

feature
	change_start (e : D_EXPRESSION)
		-- change starting expression
		do
			start := e
		end

feature {C_BUILDER} -- Builder implementation
	build (b : C_BUILDER)
		-- Build on this expression
		do
			b.c_start (current)
		end

feature {D_VISITOR} -- Visitor implementation
	accept (v : D_VISITOR)
		-- Accept a visitor
		do
			v.c_start (current)
		end
end
