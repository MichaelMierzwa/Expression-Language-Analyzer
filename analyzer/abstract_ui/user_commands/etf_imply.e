note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_IMPLY
inherit
	ETF_IMPLY_INTERFACE
		redefine imply end
create
	make
feature -- command
	imply
    	do
			-- perform some update on the model state
			model.update_exp(create {C_IMPLIES}.make)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
