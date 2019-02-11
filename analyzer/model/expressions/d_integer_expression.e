note
	description: "an integer expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_INTEGER_EXPRESSION

inherit
	D_EXPRESSION

feature {NONE} -- Attributes
	val : INTEGER_64

feature -- Queries
	get_val : INTEGER_64
		do
			result := val
		ensure
			correct_result: result = val
		end

feature -- Mutators
	set_val (v : INTEGER_64)
		do
			val := v
		ensure
			val_changed: val = v
		end
end
