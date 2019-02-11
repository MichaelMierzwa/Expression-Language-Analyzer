note
	description: "A binary operator"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_BINARY_OP

inherit
	D_OPERATOR

feature {NONE} -- Attributes
	first : D_EXPRESSION
	second : D_EXPRESSION

feature {NONE} -- Constructor
	make
		-- Initialize a binary operator
		do
			first := create {C_DUMMY}.make
			second := create {C_DUMMY}.make
		ensure
			Initialized_first: attached {C_DUMMY} get_first
			Initialized_second: attached {C_DUMMY} get_second
		end

feature -- Queries
	get_first : D_EXPRESSION
		-- Get first child
		do
			result := first
		ensure
			correct_result: result = first
		end

	get_second : D_EXPRESSION
		-- Get second child
		do
			result := second
		ensure
			correct_result: result = second
		end

feature -- mutators
	change_first (e : D_EXPRESSION)
		-- Change first child
		do
			first := e
		ensure
			first_changed: first = e
		end

	change_second (e : D_EXPRESSION)
		-- Change second child
		do
			second := e
		ensure
			second_changed: second = e
		end


end
