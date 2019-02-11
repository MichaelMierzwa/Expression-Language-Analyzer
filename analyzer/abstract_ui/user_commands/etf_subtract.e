note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SUBTRACT
inherit
	ETF_SUBTRACT_INTERFACE
		redefine subtract end
create
	make
feature -- command
	subtract
    	do
			-- perform some update on the model state
			model.update_exp(create {C_MINUS}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
