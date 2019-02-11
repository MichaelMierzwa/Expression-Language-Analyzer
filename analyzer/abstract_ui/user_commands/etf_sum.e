note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SUM
inherit
	ETF_SUM_INTERFACE
		redefine sum end
create
	make
feature -- command
	sum
    	do
			-- perform some update on the model state
			model.update_exp(create {C_SUM}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
