note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_CONJOIN
inherit
	ETF_CONJOIN_INTERFACE
		redefine conjoin end
create
	make
feature -- command
	conjoin
    	do
			-- perform some update on the model state
			model.update_exp (create {C_AND}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
