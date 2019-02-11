note
	description: "A set expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_SET_EXPRESSION

inherit
	D_EXPRESSION
	ITERABLE[D_EXPRESSION]

feature {NONE} -- Constructor
	make
		-- Initialize a set expression
		do
			create area.make
			open := true
			type := 0
		end

feature {NONE}
	area : LINKED_LIST[D_EXPRESSION]
	open : BOOLEAN
	type : INTEGER

feature -- set types
	undefined : INTEGER = 0
	t_boolean : INTEGER = 1
	t_integer : INTEGER = 2

feature -- Queries
	is_open : BOOLEAN
		-- Is the set open?
		do
			result := open
		ensure
			correct_result: result = open
		end

	is_empty : BOOLEAN
		-- Is the set empty?
		do
			result := area.is_empty
		ensure
			correct_result: result = area.is_empty
		end

	get_area : LINKED_LIST[D_EXPRESSION]
		-- Get the area of the set expression
		do
			result := area.twin
		ensure
			correct_result: result ~ area
		end
	return_type : INTEGER
		do
			result := type
		ensure
			correct_result: result = type
		end


feature -- Implementation
	extend (e : D_EXPRESSION)
		-- Add e into the set
		require
			is_open : is_open
		do
			area.extend (e)
		ensure
			others_unchanged:
				across
					1 |..| ((old area).count) as i
				all
					area.at (i.item) ~ (old area).at (i.item)
				end
			value_added:
				area.last = e
		end

	close
		-- close the set
		do
			open := false
		ensure
			closed: open = false
		end

	set_type (i : INTEGER)
		do
			type := i
		ensure
			type_changed: type = i
		end

feature -- Implementation of iterable
	new_cursor : ITERATION_CURSOR[D_EXPRESSION]
		-- Get iteration cursor
		do
			result := area.new_cursor
		end
end
