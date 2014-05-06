time = {}
timer = {}

function timer.newTime()
	print(#time)
	table.insert(time, 0)
	return #time
end

function timer.update(dt)
	for i,v in pairs(time) do
		table.remove(time, i)
		table.insert(time, i, v + dt)
	end
end

function timer.get(i)
	return time[i]
end

function timer.delete(i)
	table.remove(time,i)
end