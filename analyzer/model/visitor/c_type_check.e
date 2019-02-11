note
    description: "Summary description for {C_TYPE_CHECK}."
    author: "Michael Mierzwa"
    date: "$Date$"
    revision: "$Revision$"

class
    C_TYPE_CHECK
inherit
    D_VISITOR
    	redefine
    		out
    	end

create
    make

feature --Constructor
    make (s : C_START)
    do
        start:= s
        not_full:= false
        not_tc:= false
        create error_not_tc.make_from_string (" is not type-correct.")
        create error_not_full.make_from_string ("Error (Expression is not yet fully specified).")
        create correct_msg.make_from_string (" is type-correct.")
    end --make

feature{NONE} --Private Attributes
    start:C_START
	not_full:BOOLEAN
	not_tc:BOOLEAN
    error_not_tc:STRING
    error_not_full:STRING
    correct_msg:STRING

feature --Queries
    has_error:BOOLEAN
        --Return false if type-correct, true otherwise.
        do
            Result:= not_full or else not_tc
        end --has_error

	error_string:STRING
        do
            if
                not_full
            then
                create Result.make_from_string("not_full")
            elseif not_tc then
                create Result.make_from_string("not_tc")
            else
                create Result.make_from_string("no_err")
            end
        end --error_string

    out:STRING
        --Return message generated after type-check.
        --If is correct so far, returns " is type-correct",
        do
            if not_full then
                create Result.make_from_string(error_not_full)
            elseif not_tc then
                create Result.make_from_string(error_not_tc)
            else
                create Result.make_from_string(correct_msg)
            end
        end --out

	typec
		do
			not_full:= false
			not_tc:=false
			start.accept (current)
		end --typec


feature --Visitor Features
    c_and (h : C_AND)
        --AND has children of type boolean_expression, and returns a boolean.
        do
            if not has_error then
            	if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_BOOLEAN_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_BOOLEAN_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --and

    c_boolean_constant (h : C_BOOLEAN_CONSTANT)
        --No type checking needed for a constant.
        do
        end

    c_difference (h : C_DIFFERENCE)
        --DIFFERENCE has children of type set_expression, and returns a set.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_SET_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_SET_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --difference

    c_divides (h : C_DIVIDES)
        --DIVIDE has children of type integer_expression, and returns an integer.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_INTEGER_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --divides

    c_dummy (h : C_DUMMY)
        --We don't check dummies.
        do
        end

    c_equal (h : C_EQUAL)
        --EQUAL has children of type integer_expression, and returns a boolean.
        local
        	seenB,seenI,seenS: INTEGER
        do
        	seenB:= 0
        	seenI:= 0
        	seenS:= 0
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                	seenI:= seenI +1
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                    --After visiting left child, check that second child is same type,
                    --And that we are still type-correct (not has_error).
                    if not not_full then
                        if attached {C_DUMMY}h.get_second then
            				not_full:=true
             		    elseif attached {D_INTEGER_EXPRESSION} h.get_second as child2 then
                            --If the right child is of the proper type, visit it.
                            child2.accept (current)
                        else
                            not_tc:= true
                        end
                    end
                else
                    if attached {D_SET_EXPRESSION} h.get_first as child1 then
                        --If the left child is of the proper type, visit it.
                        seenS:= seenS +1
                        child1.accept (current)
                        --After visiting left child, check that second child is same type,
                        --And that we are still type-correct (not has_error).
                        if not not_full then
                            if attached {C_DUMMY}h.get_second then
            					not_full:=true
                			elseif attached {D_SET_EXPRESSION} h.get_second as child2 then
                                --If the right child is of the proper type, visit it.
                                child2.accept (current)
                            else
                                not_tc:= true
                            end
                        end
                    else
                        if attached {D_BOOLEAN_EXPRESSION} h.get_first as child1 then
                            --If the left child is of the proper type, visit it.
                            seenB:= seenB +1
                            child1.accept (current)
                            --After visiting left child, check that second child is same type,
                            --And that we are still type-correct (not has_error).
                            if not not_full then
                                if attached {C_DUMMY}h.get_second then
            						not_full:=true
               					elseif attached {D_BOOLEAN_EXPRESSION} h.get_second as child2 then
                                    --If the right child is of the proper type, visit it.
                                    child2.accept (current)
                                else
                                    not_tc:= true
                                end
                            end
                        else
                            --if after checking all three possible equality cases,
                            --we haven't found a cast, we are not type-correct
                            not_tc:= true
                        end -- attached boolean
                    end --attached set
                end --attached int

                if
                	(seenI * seenB) + (seenI * seenS) + (seenS * seenB) /= 0
                then
                	not_tc:= true
                end
            end --has_error check
        end --equals

    c_exists (h : C_EXISTS)
        --EXISTS has child of type set_expression (soley of boolean expressions), and returns a boolean.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_SET_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    --children in the set are all boolean expressions
                    if(child1.is_empty or else child1.is_open) then
	                    not_full:=true
	                else
	            		across
	                    	child1 as cursor
	                    loop
	                    	if(not(not_full)) then
	                    		if attached {C_DUMMY}cursor.item then
	            					not_full:=true
	                			elseif attached {D_BOOLEAN_EXPRESSION} cursor.item as cchild then
	                    			cchild.accept (current)
	                    		else
	                    			not_tc:= true
	                    		end
	                    	end --has_error check
	                    end --across children in set
					end --open check
                else
                    not_tc:= true
                end
            end
        end --exists

    c_for_all (h : C_FOR_ALL) --is currently wrong
        --FORALL has child of type set_expression (soley of boolean expressions), and returns a boolean.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_SET_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    --children in the set are all boolean expressions
                    if(child1.is_empty or else child1.is_open) then
	                    not_full:=true
	                else
	                    across
	                    	child1 as cursor
	                    loop
	                    	if(not(not_full)) then
	                    		if attached {C_DUMMY}cursor.item then
	            					not_full:=true
	              				elseif attached {D_BOOLEAN_EXPRESSION} cursor.item as cchild then
	                    			cchild.accept (current)
	                    		else
	                    			not_tc:= true
	                    		end
	                    	end --has_error check
	                    end --across children in set
					end --open check
                else
                    not_tc:= true
                end
            end
        end --for_all

    c_gt (h : C_GT)
        --GT has children of type integer_expression, and returns a boolean.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end


	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_INTEGER_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --gt

    c_implies (h : C_IMPLIES)
        --IMPLIES has children of type boolean_expression, and returns a boolean.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_BOOLEAN_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_BOOLEAN_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end -- implies

    c_integer_constant (h : C_INTEGER_CONSTANT)
        --No type checking needed for a constant.
        do
        end

    c_intersect (h : C_INTERSECT)
        --INTERSECT has children of type set_expression, and returns a set.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_SET_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_SET_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --intersect

    c_lt (h : C_LT)
        --LT has children of type integer_expression, and returns a boolean.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_INTEGER_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --lt

    c_minus (h : C_MINUS)
        --MINUS has children of type integer_expression, and returns an integer.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_INTEGER_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --minus

    c_negation (h : C_NEGATION)
        --NEGATION has child of type boolean_expression, and returns a boolean.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_BOOLEAN_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end
            end
        end

  	c_negative (h : C_NEGATIVE)
  		--NEGATIVE has child of type integer_expression, and returns an integer.
		do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end
            end
		end

    c_or (h : C_OR)
        --OR has children of type boolean_expression, and evaluates to a set_boolean.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_BOOLEAN_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_BOOLEAN_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end

    c_plus (h : C_PLUS)
        --PLUS has children of type integer_expression, and returns an integer.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_INTEGER_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --plus

    c_set (h : C_SET)
    	--SET is of type expression.
		local
			seenB, seenI, seenS:BOOLEAN

        do
        	seenB:= false
        	seenI:= false
        	seenS:= false
        	h.set_type (h.undefined)


        	if(not(has_error))then
        		if h.is_open then
        			not_full:= true
        		else
        			across
        				h as child
        			loop
        				if attached {C_DUMMY}child.item then
      						not_full:= true
      					else
      						if(seenB and then not(seenI) and then not(seenS) )then
      							if attached {D_BOOLEAN_EXPRESSION} child.item as c then
									if h.return_type /= h.t_boolean then
										not_tc:=true
									end
									c.accept(current)
								else
									not_tc:= true
								end
      						elseif (seenI and then not(seenB) and then not(seenS) ) then
      							if attached {D_INTEGER_EXPRESSION} child.item as c then
									if h.return_type /= h.t_integer then
										not_tc:=true
									end
									c.accept(current)
								else
									not_tc:= true
								end
							elseif (seenS and then not(seenB) and then not(seenI) ) then
      							if attached {D_SET_EXPRESSION} child.item as c then
									c.accept(current)
									if h.return_type /= c.return_type then
										not_tc:=true
									end
								else
									not_tc:= true
								end
							elseif(not(seenB) and then not(seenI) and then not(seenS)) then
								if attached {D_INTEGER_EXPRESSION} child.item as c then
									h.set_type (h.t_integer)
									c.accept(current)
									seenI:= true
								elseif attached {D_BOOLEAN_EXPRESSION} child.item as c then
									h.set_type (h.t_boolean)
									c.accept(current)
									seenB:= true
								elseif attached {D_SET_EXPRESSION} child.item as c then

									c.accept(current)
									seenS:= true
									h.set_type (c.return_type)
								else
									not_tc:= true
								end

							else
								not_tc:=true
      						end
        				end --attach
        			end --across

        		end --is open
        	end  --has error
        end --set

    c_start (h : C_START)
    	--START is of type expression
        do
            if not has_error then
                if attached {C_DUMMY} h.get_start then
                    not_full:= true
                else
                    h.get_start.accept(current)
                end
            end
        end

    c_sum (h : C_SUM)
    	--SUM had child of type set_expression, and returns an integer.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_SET_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    --children in the set are all boolean expressions
                    if(child1.is_empty or else child1.is_open) then
	                    not_full:=true
	                else
	                    across
	                    	child1 as cursor
	                    loop
	                    	if(not(not_full)) then
	                    		if attached {C_DUMMY}cursor.item then
	            					not_full:=true
	               				elseif attached {D_INTEGER_EXPRESSION} cursor.item as cchild then
	                    			cchild.accept (current)
	                    		else
	                    			not_tc:= true
	                    		end
	                    	end --has_error check
	                    end --across children in set
					end --open check
                else
                    not_tc:= true
                end
            end
        end


    c_times (h : C_TIMES)
        --TIMES has children of type integer_expression, and returns an integer.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_INTEGER_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	                if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_INTEGER_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --times

    c_union (h : C_UNION)
        --UNION has children of type set_expression, and returns a set.
        do
            if not has_error then
                if attached {C_DUMMY}h.get_first then
            		not_full:=true
                elseif attached {D_SET_EXPRESSION} h.get_first as child1 then
                    --If the left child is of the proper type, visit it.
                    child1.accept (current)
                else
                    not_tc:= true
                end

	            --After visiting left child, check that we are still type-correct (not has_error).
	            if not not_full then
	               if attached {C_DUMMY}h.get_second then
	            		not_full:=true
	                elseif attached {D_SET_EXPRESSION} h.get_second as child2 then
	                    --If the right child is of the proper type, visit it.
	                    child2.accept (current)
	                else
	                    not_tc:= true
	                end
	            end
            end
        end --union
end --end of c_type_check
