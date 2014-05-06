col = {}

function col.isAinB(ax, ay, bx1, by1, bx2, by2)
	if ax >= bx1 and ax <= bx2 then
		if ay >= by1 and ay <= by2 then
			return true
		end
	end

	return false
end 