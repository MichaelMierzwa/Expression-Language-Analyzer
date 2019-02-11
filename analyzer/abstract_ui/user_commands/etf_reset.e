note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_RESET
inherit
	ETF_RESET_INTERFACE
		redefine reset end
create
	make
feature -- command
	reset
    	do
			-- perform some update on the model state
			model.update (current)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
