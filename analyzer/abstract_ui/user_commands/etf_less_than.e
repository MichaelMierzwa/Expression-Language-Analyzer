note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LESS_THAN
inherit
	ETF_LESS_THAN_INTERFACE
		redefine less_than end
create
	make
feature -- command
	less_than
    	do
			-- perform some update on the model state
			model.update_exp(create {C_LT}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
