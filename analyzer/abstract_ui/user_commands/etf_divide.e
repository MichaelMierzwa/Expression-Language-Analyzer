note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DIVIDE
inherit
	ETF_DIVIDE_INTERFACE
		redefine divide end
create
	make
feature -- command
	divide
    	do
			-- perform some update on the model state
			model.update_exp(create {C_DIVIDES}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
