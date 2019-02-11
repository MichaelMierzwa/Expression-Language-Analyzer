note
	description: "Summary description for {C_EVALUATE}."
	author: "Dusan Putnikovic"
	date: "$Date$"
	revision: "$Revision$"

class
	C_EVALUATE

inherit
	D_VISITOR
		redefine
			out
		end

create
	make

feature {NONE} -- constructor
	make ( s : C_START)
	do

		start := s
		error := false
		create pp_start.make
		create error_divide_by_zero.make_from_string ("Error (Divisor is zero).")
		create pp.make (pp_start)

	end

feature {NONE}-- attributes
	error : BOOLEAN
	pp_start : C_START
	start : C_START
	error_divide_by_zero : STRING
	pp : C_PRETTY_PRINTING

feature -- error control and output
	has_error : BOOLEAN
	do
		result := error
	end

	get_error : STRING
	do
		create Result.make_empty
		if has_error then
			Result.append(error_divide_by_zero)
		end
	end

	out : STRING
	do
       	Result := pp.pretty_print
   	end

feature -- evaluate feature
   	evaluate
   	local
   		set : SET[D_EXPRESSION]
   		vset : C_SET
   	do
   		if not has_error then
	   		start.accept(current)
	   		if attached {D_INTEGER_EXPRESSION} start.get_start as int then
	   			pp_start.change_start (create {C_INTEGER_CONSTANT}.make (int.get_val))
	   		elseif attached {D_BOOLEAN_EXPRESSION} start.get_start as boole then
	   			pp_start.change_start (create {C_BOOLEAN_CONSTANT}.make (boole.get_val))
	   		elseif attached {D_SET_EXPRESSION} start.get_start as sets then
	   			create set.make_empty
	   			create vset.make
	   			across
	   				sets as vals
	   			loop
	   				if attached {D_INTEGER_EXPRESSION} vals.item as i then
	   					set.extend (create {C_INTEGER_CONSTANT}.make (i.get_val))
	   				elseif attached {D_BOOLEAN_EXPRESSION} vals.item as i then
	   					set.extend (create {C_BOOLEAN_CONSTANT}.make (i.get_val))
	   				end
	   			end

	   			across
	   				set as s
	   			loop
					vset.extend (s.item)
	   			end

	   			vset.close
	   			pp_start.change_start (vset)
			end
   		end
   	end

feature {C_AND} -- visitor pattern implementation
	c_and (h : C_AND)
		-- evaluate for and
		do
			check attached {D_BOOLEAN_EXPRESSION}h.get_first as l then
				check attached {D_BOOLEAN_EXPRESSION}h.get_second as r then
					h.set_val (l.get_val and r.get_val)
				end
			end
		end

feature {C_BOOLEAN_CONSTANT}
	-- evaluate the boolean constant
	c_boolean_constant (h : C_BOOLEAN_CONSTANT)
		-- evaluate for boolean constant
		do
			-- DO NOTHING CONSTANTS ALREADY HAVE VALUES SET
		end

	c_close_set (h : C_CLOSE_SET)
		do
			-- sets
		end

feature {C_DIFFERENCE}
	-- evaluate the difference of two sets
	c_difference (h : C_DIFFERENCE)
	local
		left : SET[D_EXPRESSION]
		right : SET[D_EXPRESSION]
		difference : SET[D_EXPRESSION]
		do
			h.get_first.accept (current)
			h.get_second.accept (current)
			create left.make_empty
			create right.make_empty
			create difference.make_empty
			if attached {D_SET_EXPRESSION} h.get_first as l then
				if attached {D_SET_EXPRESSION} h.get_second as r then

					across l
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							left.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							left.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end
					across r
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							right.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							right.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end
				end
			end
			left.difference (right)
			across left
			as iterator
			loop
				h.extend (iterator.item)
			end

			h.close

		end
feature {C_DIVIDES}
-- evaluate for division
	c_divides (h : C_DIVIDES)
	do
		if not error then -- if there is no error
			if attached {D_INTEGER_EXPRESSION} h.get_first as l then
				h.get_first.accept (current) -- get left child
			end
		else
			error := true
		end

		if not error  then
			if attached {D_INTEGER_EXPRESSION} h.get_second as r then
				h.get_second.accept(current)
				if r.get_val = 0 then
					error := true
				end  -- get right child
			end
		else
			error := true
		end

		if not error then
			check attached {D_INTEGER_EXPRESSION} h.get_first as first
			then
				check attached {D_INTEGER_EXPRESSION} h.get_second as second
				then
					h.set_val ( (first.get_val / second.get_val).truncated_to_integer_64)
				end
			end
		end

	end
feature {C_DUMMY}
	c_dummy (h : C_DUMMY)
		do
			-- Do nothing for dummy
		end

feature {C_EQUAL}
-- calculate the equality of two expressions
	c_equal (h : C_EQUAL)
	local
		left : SET[D_EXPRESSION]
		right : SET[D_EXPRESSION]
		do
			h.get_first.accept (current)
			h.get_second.accept (current)

			if attached {D_BOOLEAN_EXPRESSION} h.get_first as l then
				check attached {D_BOOLEAN_EXPRESSION} h.get_second as r then
					h.set_val (l.get_val = r.get_val)

				end
			elseif
				attached {D_INTEGER_EXPRESSION} h.get_first as l then
					check attached {D_INTEGER_EXPRESSION} h.get_second as r then
						h.set_val (l.get_val = r.get_val)
				 end
			elseif attached {D_SET_EXPRESSION} h.get_first as l then
				check attached {D_SET_EXPRESSION} h.get_second as r then
					create left.make_empty
					create right.make_empty

					across l
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							left.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							left.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end

					across l
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							right.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							right.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end
				end
				h.set_val (left ~ right)
			end
		end

feature {C_EXISTS}
-- calculate the existential quantifier
	c_exists (h : C_EXISTS)
		do
		h.set_val (false)
		check attached {D_SET_EXPRESSION}h.get_first as l then
			across l
			as it
			loop
				check attached {D_BOOLEAN_EXPRESSION} it.item as c then
					c.accept (current)
					h.set_val (h.get_val or c.get_val)
				end
			end
		end
		end

feature {C_FOR_ALL}
-- calculate the universal quantifier
	c_for_all (h : C_FOR_ALL)
	do
		h.set_val (true)
		check attached {D_SET_EXPRESSION}h.get_first as l then
			across l
			as it
			loop
				check attached {D_BOOLEAN_EXPRESSION} it.item as c then
					c.accept (current)
					h.set_val (h.get_val and c.get_val)
				end
			end
		end
	end

feature {C_GT}
		-- calculate greater than
	c_gt (h : C_GT)
		do
			check attached {D_INTEGER_EXPRESSION}h.get_first as l then
				check attached {D_INTEGER_EXPRESSION}h.get_second as r then
					h.set_val (l.get_val > r.get_val)
				end
			end
		end

feature {C_IMPLIES}
		-- calculate the Implication boolean
	c_implies (h : C_IMPLIES)
		do
			check attached {D_BOOLEAN_EXPRESSION}h.get_first as l then
				check attached {D_BOOLEAN_EXPRESSION}h.get_second as r then
					h.set_val (l.get_val implies r.get_val)
				end
			end
		end

feature {C_INTEGER_CONSTANT}
	c_integer_constant (h : C_INTEGER_CONSTANT)
		do
			-- DO NOTHING CONSTANTS HAVE EVERYTHING SET
		end

feature {C_INTERSECT}
	-- calculate the set intersection
	c_intersect (h : C_INTERSECT)
	local
		left : SET[D_EXPRESSION]
		right : SET[D_EXPRESSION]
		difference : SET[D_EXPRESSION]
		do
			h.get_first.accept (current)
			h.get_second.accept (current)
			create left.make_empty
			create right.make_empty
			create difference.make_empty
			if attached {D_SET_EXPRESSION} h.get_first as l then
				if attached {D_SET_EXPRESSION} h.get_second as r then

					across l
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							left.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							left.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end
					across r
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							right.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							right.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end
				end
			end
			left.intersect(right)
			across left
			as iterator
			loop
				h.extend (iterator.item)
			end

			h.close

		end

feature {C_LT}
	-- calculate the less than expression
	c_lt (h : C_LT)
		do

			if not error then

				if attached {D_INTEGER_EXPRESSION} h.get_first as c then
					h.get_first.accept(current)
				else
					error := true
				end

				if attached {D_INTEGER_EXPRESSION} h.get_second as c then
					h.get_second.accept (current)
				else
					error := true
				end

				check attached {D_INTEGER_EXPRESSION} h.get_first as first
				then
					check attached {D_INTEGER_EXPRESSION} h.get_second as second
					then
						h.set_val (first.get_val < second.get_val)
					end
				end
			end
		end

feature {C_MINUS}
	-- calculate one minus another
	c_minus (h : C_MINUS)
		do
			if not error then
				if attached {D_INTEGER_EXPRESSION} h.get_first as c then
					h.get_first.accept (current)
				else
					-- ERROR MESSAGE SET
					error := true
				end
			end

			if not error then
				if attached {D_INTEGER_EXPRESSION} h.get_second as c then
					h.get_second.accept (current)
				else
					-- ERROR MESSAGE SET
					error := true
				end
			end

			if not error then
				check attached {D_INTEGER_EXPRESSION} h.get_first as f
				then
					check attached {D_INTEGER_EXPRESSION} h.get_second  as s
					then
						h.set_val (f.get_val - s.get_val)
					end
				end
			end
		end

feature {C_NEGATION}
	-- calculate the negation of a boolean expression
	c_negation (h : C_NEGATION)
	do
		if not error then -- if there is no error
			check attached {D_BOOLEAN_EXPRESSION} h.get_first as s then
				h.set_val ( not s.get_val ) -- negate the expression
			end
		else
			error := true
		end
	end

feature {C_NEGATIVE}
	-- puts a minus before an integer expression
	c_negative (h : C_NEGATIVE)
	do
		if not error then -- if there is no error
			check attached {D_INTEGER_EXPRESSION} h.get_first as l then
				h.set_val ( (-l.get_val) )
			end
		else
			error := true
		end
	end

feature {C_OPEN_SET}
	-- do nothing
	c_open_set (h : C_OPEN_SET)
		do
				-- Do nothing this is not required by analyzer
		end

feature {C_OR}
	-- calculate the discjunction of expressions
	c_or (h : C_OR)
		do
			check attached {D_BOOLEAN_EXPRESSION} h.get_first as l then
				check attached {D_BOOLEAN_EXPRESSION} h.get_second as r then
					h.set_val (l.get_val or r.get_val)
				end
			end
		end

feature {C_PLUS}
	-- calculate the addition of expressions
	c_plus (h : C_PLUS)
		do
			if not error then
				if attached {D_INTEGER_EXPRESSION} h.get_first as c then
					h.get_first.accept (current)
				else
					-- ERROR MESSAGE SET
					error := true
				end
			end

			if not error then
				if attached {D_INTEGER_EXPRESSION} h.get_second as c then
					h.get_second.accept (current)
				else
					-- ERROR MESSAGE SET
					error := true
				end
			end

			if not error then
				check attached {D_INTEGER_EXPRESSION} h.get_first as f
				then
					check attached {D_INTEGER_EXPRESSION} h.get_second  as s
					then
						h.set_val (f.get_val + s.get_val)
					end
				end
			end
		end

feature {C_SET}
	-- evaluate a set
	c_set (h : C_SET)
		do
			if h.is_open then
			 	error := true
			else
				across
					h as a
				loop
					a.item.accept (current)
				end
			end
		end

feature {C_START}
	--- the starting node of visitor pattern
	c_start (h : C_START)
		do
			h.get_start.accept (current)
		end

feature {C_SUM}
	-- the sumation of all the expressions within a set
	c_sum (h : C_SUM)
		local
			set : SET[D_EXPRESSION]
		do
		create set.make_empty
		h.set_val (0)
		check attached {D_SET_EXPRESSION}h.get_first as l then
			across l
			as it
			loop
				check attached {D_INTEGER_EXPRESSION} it.item as c then
					c.accept (current)
					set.extend (c)
				end
			end
		end

		across
			set as s
		loop
			check attached {D_INTEGER_EXPRESSION} s.item as int then
				h.set_val (h.get_val + int.get_val)
			end
		end

		end

feature {C_TIMES}
	-- the multiplication of expressions
	c_times (h : C_TIMES)
		do
			if not error then
				if attached {D_INTEGER_EXPRESSION} h.get_first as c then
					h.get_first.accept (current)
				else
					-- ERROR MESSAGE SET
					error := true
				end
			end

			if not error then
				if attached {D_INTEGER_EXPRESSION} h.get_second as c then
					h.get_second.accept (current)
				else
					-- ERROR MESSAGE SET
					error := true
				end
			end

			if not error then
				check attached {D_INTEGER_EXPRESSION} h.get_first as f
				then
					check attached {D_INTEGER_EXPRESSION} h.get_second  as s
					then
						h.set_val (f.get_val * s.get_val)
					end
				end
			end
		end

feature {C_UNION}
	--- evaluate a set union
	c_union (h : C_UNION)
	local
		left : SET[D_EXPRESSION]
		right : SET[D_EXPRESSION]
		do
			h.get_first.accept (current)
			h.get_second.accept (current)
			create left.make_empty
			create right.make_empty
			if attached {D_SET_EXPRESSION} h.get_first as l then
				if attached {D_SET_EXPRESSION} h.get_second as r then

					across l
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							left.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							left.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end
					across r
					as it
					loop
						if attached {D_BOOLEAN_EXPRESSION} it.item as it1 then
							right.extend(create{C_BOOLEAN_CONSTANT}.make (it1.get_val))
						elseif attached {D_INTEGER_EXPRESSION} it.item as it2 then
							right.extend(create {C_INTEGER_CONSTANT}.make (it2.get_val))
						end
					end
				end
			end
			left.union(right) -- union the two sets into left
			across left -- go across left
			as iterator
			loop
				h.extend (iterator.item) -- add that element to the set result
			end

			h.close -- close the set

		end
end
