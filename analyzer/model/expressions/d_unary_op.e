note
	description: "An unary operator"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_UNARY_OP

inherit
	D_OPERATOR

feature {NONE} -- Constructor
	make
		-- Initialize an unary operator
		do
			first := create {C_DUMMY}.make
		end

feature {NONE} -- Attributes
	first : D_EXPRESSION

feature -- accessors
	get_first : D_EXPRESSION
		do
			result := first
		ensure
			correct_result: result = first
		end

feature -- mutators
	change_first (e : D_EXPRESSION)
		do
			first := e
		ensure
			first_changed: first = e
		end
end
