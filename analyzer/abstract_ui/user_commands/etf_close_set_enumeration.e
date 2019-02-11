note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_CLOSE_SET_ENUMERATION
inherit
	ETF_CLOSE_SET_ENUMERATION_INTERFACE
		redefine close_set_enumeration end
create
	make
feature -- command
	close_set_enumeration
    	do
			-- perform some update on the model state
			model.update_exp(create {C_CLOSE_SET}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
