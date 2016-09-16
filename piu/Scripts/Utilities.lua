-- Lua lacks too much basic stuff...
JoinTable = function(self, delim)
	if not delim then delim = " "; end

	local ret = "";
	for s in ivalues(self) do
		if ret ~= "" then ret = ret .. delim; end
		ret = ret .. s;
	end
	return ret;
end

--commas to separate thousands
function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

--round to idp decimal places
function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end