player.jetpack = {}

function player.jetpackLoad()
	player.jetpack.img = LG.newImage("img/jetpack.png")
	player.jetpack.quad = { LG.newQuad(0, 0, 12, 20, 36, 20),
							LG.newQuad(12, 0, 12, 20, 36, 20),
							LG.newQuad(24, 0, 12, 20, 36, 20)
							}
	player.jetpack.quadnum = 1

	player.jetpack.checkpoint = 0

	time = 0
end

function player.jetpackUpdate(dt)
	time = time + dt
	if time > 0.4 then
		player.jetpack.quadnum = player.jetpack.quadnum + 1
		if player.jetpack.quadnum > 3 then
			player.jetpack.quadnum = 1
		end
		time = 0
	end
	if LK.isDown(" ") then
		player.sy = math.min(player.sy - player.ay*dt, 80)
	end
	if LK.isDown("d") then
		player.sx = math.min(player.sx + 2*player.ax*dt, 60)
	elseif LK.isDown("a") then
		player.sx = math.min(player.sx - 2*player.ax*dt, 60)
	end


	player.sy = player.sy + 9.81*dt
	player.sx = player.sx - sign(player.sx)*10*dt

	local minDistance = 1000
	nearestx = 0
	nearesty = 0
	for i,v in ipairs(player.path) do
		if i%2 == 1 then
			if math.sqrt((v-player.x)^2 + (player.path[i+1] - player.y)^2) < minDistance then
				minDistance = math.sqrt((v-player.x)^2 + (player.path[i+1] - player.y)^2)
				nearestx = v
				nearesty = player.path[i+1]
			end
		end
	end

	if math.abs(player.x + player.sx*dt - nearestx) > player.radius - 3 then
		if math.abs(player.x - nearestx) > player.radius + 3 then
			player.x = nearestx - sign(player.x - nearestx)*3
		end
		player.sx = -0.4*player.sx
	end
	if math.abs(player.y + player.sy*dt - nearesty) > player.radius - 3 then
		if math.abs(player.y - nearesty) > player.radius + 3 then
			player.y = nearesty - sign(player.y - nearesty)*3
		end
		player.sy = -0.4*player.sy
	end

	player.x = player.x + player.sx*dt
	player.y = player.y + player.sy*dt

	if player.y < 100 then
		player.state = "finished"
		player.x = 140
		player.y = 0
	end
end

function player.jetpackDraw()
	if sign(player.sx) == 0 then local sx = 1 else local sx = -sign(player.sx) end 
	LG.draw(player.jetpack.img, player.jetpack.quad[player.jetpack.quadnum], player.x, player.y, 0, sx, 1, 6, 10)
end