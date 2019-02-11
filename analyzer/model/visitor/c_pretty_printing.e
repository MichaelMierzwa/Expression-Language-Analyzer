note
	description: "Pretty printer for expressions"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	C_PRETTY_PRINTING

inherit
	D_VISITOR

create
	make

feature {NONE} -- Constructor
	make (s : C_START)
		-- Initialize a pretty printer
		do
			create outstr.make_empty
			start := s
			qmark := false
		ensure
			outstr_initialized: outstr.is_empty
			start_initialized: start = s
			qmark_initialized: qmark = false
		end

feature {NONE} -- Attributes
	outstr : STRING
	start : C_START
	qmark : BOOLEAN

feature
	pretty_print : STRING
		-- get pretty printing of expression
		do
			create outstr.make_empty
			qmark := false
			start.accept (current)
			create result.make_from_string (get_str)
		ensure
			correct_result: result ~ get_str
		end

	get_str : STRING
		-- gets last pretty printed instance
		do
			create result.make_from_string (outstr)
		ensure
			correct_result: result ~ outstr
		end

feature {C_AND}
	c_and (h : C_AND)
		-- Pretty print and expression
		do
			d_binary_op (h)
		end

feature {C_BOOLEAN_CONSTANT}
	c_boolean_constant (h : C_BOOLEAN_CONSTANT)
		-- Pretty print boolean constant expression
		do
			outstr.append(h.get_val.out)
		end

feature {C_CLOSE_SET}
	c_close_set (h : C_CLOSE_SET)
		-- Pretty print close set expression
		do
			-- ERROR
		end

feature {C_DIFFERENCE}
	c_difference (h : C_DIFFERENCE)
		-- Pretty print diffrence expression
		do
			d_binary_op (h)
		end

feature {C_DIVIDES}
	c_divides (h : C_DIVIDES)
		-- Pretty print divides expression
		do
			d_binary_op (h)
		end

feature {C_DUMMY}
	c_dummy (h : C_DUMMY)
		-- Pretty print dummy expression
		do
			if not qmark then
				outstr.append ("?")
				qmark := true
			else
				outstr.append ("nil")
			end
		end

feature {C_EQUAL}
	c_equal (h : C_EQUAL)
		-- Pretty print equal expression
		do
			d_binary_op(h)
		end

feature {C_EXISTS}
	c_exists (h : C_EXISTS)
		-- Pretty print exists expression
		do
			d_unary_op (h)
		end

feature {C_FOR_ALL}
	c_for_all (h : C_FOR_ALL)
		-- Pretty print for all expression
		do
			d_unary_op (h)
		end

feature {C_GT}
	c_gt (h : C_GT)
		-- Pretty print greater than expression
		do
			d_binary_op(h)
		end

feature {C_IMPLIES}
	c_implies (h : C_IMPLIES)
		-- Pretty print implies expression
		do
			d_binary_op(h)
		end

feature {C_INTEGER_CONSTANT}
	c_integer_constant (h : C_INTEGER_CONSTANT)
		-- Pretty print integer constant expression
		do
			outstr.append (h.get_val.out)
		end

feature {C_INTERSECT}
	c_intersect (h : C_INTERSECT)
		-- Pretty print intersect expression
		do
			d_binary_op(h)
		end

feature {C_LT}
	c_lt (h : C_LT)
		-- Pretty print less than expression
		do
			d_binary_op(h)
		end

feature {C_MINUS}
	c_minus (h : C_MINUS)
		-- Pretty print minus expression
		do
			d_binary_op(h)
		end

feature {C_NEGATION}
	c_negation (h : C_NEGATION)
		-- Pretty print negation expression
		do
			d_unary_op (h)
		end

feature {C_NEGATIVE}
	c_negative (h : C_NEGATIVE)
		-- Pretty print negative expression
		do
			d_unary_op (h)
		end

feature {C_OPEN_SET}
	c_open_set (h : C_OPEN_SET)
		-- Pretty print open set expression
		do
			-- ERROR
		end

feature {C_OR}
	c_or (h : C_OR)
		-- Pretty print or expression
		do
			d_binary_op(h)
		end

feature {C_PLUS}
	c_plus (h : C_PLUS)
		-- Pretty print plus expression
		do
			d_binary_op(h)
		end

feature {C_SET}
	c_set (h : C_SET)
		-- Pretty print set expression
		do
			outstr.append ("{")
			across
				h as c
			loop
				c.item.accept (current)
				outstr.append (", ")
			end
			if
				h.is_open
			then
				if not qmark then
					outstr.append ("?}")
					qmark := true
				else
					outstr.remove_tail (2)
					outstr.append ("}")
				end
			else
				if(not h.is_empty) then
					outstr.remove_tail (2)
				end
				outstr.append ("}")
			end

		end

feature {C_START}
	c_start (h : C_START)
		-- Pretty print start expression
		do
			h.get_start.accept (current)
		end

feature {C_SUM}
	c_sum (h : C_SUM)
		-- Pretty print sum expression
		do
			d_unary_op (h)
		end

feature {C_TIMES}
	c_times (h : C_TIMES)
		-- Pretty print times expression
		do
			d_binary_op(h)
		end

feature {C_UNION}
	c_union (h : C_UNION)
		-- Pretty print union expression
		do
			d_binary_op(h)
		end

feature {NONE}

	d_unary_op (h : D_UNARY_OP)
		-- Pretty print unary operator
		do
			outstr.append ("(")
			outstr.append (h.get_op)
			outstr.append (" ")
			h.get_first.accept (current)
			outstr.append (")")
		end

	d_binary_op (h : D_BINARY_OP)
		-- Pretty print binary operator
		do
			outstr.append ("(")
			h.get_first.accept (current)
			outstr.append (" ")
			outstr.append (h.get_op)
			outstr.append (" ")
			h.get_second.accept (current)
			outstr.append (")")
		end

end
