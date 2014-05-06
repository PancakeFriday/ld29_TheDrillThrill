function sign(x)
	if x>0 then return 1 elseif x<=0 then return -1 else return 0 end 
end

function isInTable(table, value, n)
	for i,v in pairs(table) do
		if n then
			if table[i].t == value then
				return true
			end
		else
			if v == value then
				return true
			end
		end
	end

	return false
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end