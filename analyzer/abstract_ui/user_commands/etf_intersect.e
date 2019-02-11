note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_INTERSECT
inherit
	ETF_INTERSECT_INTERFACE
		redefine intersect end
create
	make
feature -- command
	intersect
    	do
			-- perform some update on the model state
			model.update_exp (create {C_INTERSECT}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
