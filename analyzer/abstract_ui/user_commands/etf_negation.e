note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEGATION
inherit
	ETF_NEGATION_INTERFACE
		redefine negation end
create
	make
feature -- command
	negation
    	do
			-- perform some update on the model state
			model.update_exp(create {C_NEGATION}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
