note
	description: "A set unary operator expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_SET_UNARY_OP

inherit
	D_SET_EXPRESSION
		rename
			make as make_from_set_expression
		redefine
			is_equal
		end
	D_UNARY_OP
		rename
			make as make_from_unary_op
		redefine
			is_equal
		end

feature {NONE} -- Constructor
	make
		do
			make_from_set_expression
			make_from_unary_op
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
