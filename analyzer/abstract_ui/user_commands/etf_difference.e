note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DIFFERENCE
inherit
	ETF_DIFFERENCE_INTERFACE
		redefine difference end
create
	make
feature -- command
	difference
    	do
			-- perform some update on the model state
			model.update_exp(create {C_DIFFERENCE}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
