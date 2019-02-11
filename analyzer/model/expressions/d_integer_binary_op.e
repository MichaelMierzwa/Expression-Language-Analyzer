note
	description: "An integer binary operator expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_INTEGER_BINARY_OP

inherit
	D_BINARY_OP
		redefine
			is_equal
		end
	D_INTEGER_EXPRESSION
		redefine
			is_equal
		end

feature -- Equality
	is_equal (other : like current) : BOOLEAN
		-- Is current equalivalent to other?
		do
			if
				current.get_op /~ other.get_op
				and then
				current.get_first /~ other.get_first
				and then
				current.get_second /~ other.get_second
			then
				result := false
			else
				result := true
			end
		ensure then
			correct_result:
				result =
					(current.get_op /~ other.get_op) and
					(current.get_first /~ other.get_first) and
					(current.get_second /~ other.get_second)
		end
end
