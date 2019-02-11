note
	description: "A boolean expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_BOOLEAN_EXPRESSION

inherit
	D_EXPRESSION

feature {NONE} -- Attribute
	val : BOOLEAN

feature -- Queries
	get_val : BOOLEAN
		-- get evaluated value
		do
			result := val
		ensure
			correct_result: result = val
		end

feature -- Mutators
	set_val (v : BOOLEAN)
		-- set evaluated value
		do
			val := v
		ensure
			val_changed: val = v
		end
end
