note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_EVALUATE
inherit
	ETF_EVALUATE_INTERFACE
		redefine evaluate end
create
	make
feature -- command
	evaluate
    	do
			-- perform some update on the model state
			model.update (current)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
