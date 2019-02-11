note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_BOOLEAN_CONSTANT
inherit
	ETF_BOOLEAN_CONSTANT_INTERFACE
		redefine boolean_constant end
create
	make

feature -- command
	boolean_constant(c: BOOLEAN)
    	do
			-- perform some update on the model state
			model.update_exp (create {C_BOOLEAN_CONSTANT}.make (c))
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
