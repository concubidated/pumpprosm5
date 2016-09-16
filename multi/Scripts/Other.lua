function GameMode()
	return "multi";
end

function ShowTitleIcons()
	return false
end

function GetTitleMenuChoices()
	local ret = "MultiRegular,Workout,MultiNonstop"
	local b = PREFSMAN:GetPreference("ShowServiceOnTitleMenu")
	if not b  or  b == nil then
		ret = ret .. ",Service"
	end
	return ret
end

