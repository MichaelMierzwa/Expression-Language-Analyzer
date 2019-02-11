note
	description: "An operator class"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_OPERATOR

feature {NONE} -- Attributes
	op : STRING

feature -- Queries
	get_op : STRING
		-- Get the operator string
		do
			result := op
		ensure
			correct_result: result ~ op
		end
end
