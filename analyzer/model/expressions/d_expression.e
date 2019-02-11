note
	description: "An expression"
	author: "Juyoung Kim"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	D_EXPRESSION

feature {C_BUILDER} -- Builder implementation
	build (b : C_BUILDER)
		-- Build on this expression
		deferred
		end

feature {D_VISITOR} -- Visitor implementation
	accept (v : D_VISITOR)
		-- Accept a visitor
		deferred
		end
end
