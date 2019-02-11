note
	description: "Visitor interface"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_VISITOR

feature {C_AND} -- Implementation
	c_and (h : C_AND)
		-- Visit an and operator
		deferred
		end

feature {C_BOOLEAN_CONSTANT}
	c_boolean_constant (h : C_BOOLEAN_CONSTANT)
		-- Visit a boolean constant expression
		deferred
		end

feature {C_DIFFERENCE}
	c_difference (h : C_DIFFERENCE)
		-- Visit a diffrence operator
		deferred
		end

feature {C_DIVIDES}
	c_divides (h : C_DIVIDES)
		-- Visit a divides operator
		deferred
		end

feature {C_DUMMY}
	c_dummy (h : C_DUMMY)
		-- Visit a dummy operator
		deferred
		end

feature {C_EQUAL}
	c_equal (h : C_EQUAL)
		-- Visit an equal operator
		deferred
		end

feature {C_EXISTS}
	c_exists (h : C_EXISTS)
		-- Visit an exists operator
		deferred
		end

feature {C_FOR_ALL}
	c_for_all (h : C_FOR_ALL)
		-- Visit a for all operator
		deferred
		end

feature {C_GT}
	c_gt (h : C_GT)
		-- Visit a greater than operator
		deferred
		end

feature {C_IMPLIES}
	c_implies (h : C_IMPLIES)
		-- Visit an implies operator
		deferred
		end

feature {C_INTEGER_CONSTANT}
	c_integer_constant (h : C_INTEGER_CONSTANT)
		-- Visit an integer constant operator
		deferred
		end

feature {C_INTERSECT}
	c_intersect (h : C_INTERSECT)
		-- Visit an intersect operator
		deferred
		end

feature {C_LT}
	c_lt (h : C_LT)
		-- Visit a less than operator
		deferred
		end

feature {C_MINUS}
	c_minus (h : C_MINUS)
		-- Visit a minus operator
		deferred
		end

feature {C_NEGATION}
	c_negation (h : C_NEGATION)
		-- Visit a negation operator
		deferred
		end

feature {C_NEGATIVE}
	c_negative (h : C_NEGATIVE)
		-- Visit a negative operator
		deferred
		end

feature {C_OR}
	c_or (h : C_OR)
		-- Visit an or operator
		deferred
		end

feature {C_PLUS}
	c_plus (h : C_PLUS)
		-- Visit a plus operator
		deferred
		end

feature {C_SET}
	c_set (h : C_SET)
		-- Visit a set expression
		deferred
		end

feature {C_START}
	c_start (h : C_START)
		-- Visit a start expression
		deferred
		end

feature {C_SUM}
	c_sum (h : C_SUM)
		-- Visit a sum operator
		deferred
		end

feature {C_TIMES}
	c_times (h : C_TIMES)
		-- Visit a times operator
		deferred
		end

feature {C_UNION}
	c_union (h : C_UNION)
		-- Visit an union operator
		deferred
		end
end
