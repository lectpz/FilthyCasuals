require "DAMN_Base_Shared";

local DAMN = DAMN or {};
DAMN.BackCompat = DAMN.BackCompat or {};

function DAMN.BackCompat:getMulePart(vehicle)
	if vehicle
	then
		--for i, partId in ipairs(DAMN.BackCompat["muleParts"])
		for i=1,#DAMN.BackCompat["muleParts"]--lect
		do
		partId = DAMN.BackCompat["muleParts"][i]--lect
			local part = vehicle:getPartById(partId);

			if part
			then
				return part;
			end
		end

        if DAMN["backCompatDebug"]
        then
            DAMN:log("DAMN.BackCompat:getMulePart() -> mule part not found");
        end
	elseif DAMN["backCompatDebug"]
    then
		DAMN:log("DAMN.BackCompat:getMulePart() -> vehicle not found");
	end

	return nil;
end