note
	description: "An integer unary operator expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_INTEGER_UNARY_OP

inherit
	D_INTEGER_EXPRESSION
		redefine
			is_equal
		end
	D_UNARY_OP
		redefine
			is_equal
		end

feature -- Equality
	is_equal (other : like current) : BOOLEAN
		-- Is current equal to other?
		do
			if
				current.get_op /~ other.get_op
				and then
				current.get_first /~ other.get_first
			then
				result := false
			else
				result := true
			end
		ensure then
			correct_result:
				result =
					(current.get_op /~ other.get_op) and
					(current.get_first /~ other.get_first)
		end
end
