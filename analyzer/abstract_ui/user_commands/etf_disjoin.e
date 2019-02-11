note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DISJOIN
inherit
	ETF_DISJOIN_INTERFACE
		redefine disjoin end
create
	make
feature -- command
	disjoin
    	do
			-- perform some update on the model state
			model.update_exp(create {C_OR}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
