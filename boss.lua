boss = {}


function boss.load()
	boss.img = LG.newImage("img/boss/boss.png")
	boss.start = false

	boss.x = 130
	boss.y = 11300

	boss.dead = false

	boss.hitbox = {
						{ {62, 189, 78, 208} },
						{ {107, 170, 154, 208}, {121,165,144,169} }, -- eye1
						{ {162, 164, 195, 175} },
						{ {228, 171, 250, 195}, {250, 177, 261, 195} },
						{ {285, 193, 305, 207}, {305, 198, 311, 213} },
						{ {314, 248, 330, 263} },
						{ {243, 266, 268, 280}, {268, 266, 276, 276} },
						{ {105, 281, 145, 287}, {111, 287, 144, 293} },
						{ {55, 238, 63, 271}, {50, 244, 55, 264} }
	}

	boss.box = {	{59, 216, 217, 282}, {76, 193, 284, 216}, {152, 176, 232, 194},
					{216, 216, 314, 266}, {282, 200, 299, 219}, {216, 263, 243, 276},
					{95, 178, 156, 195}, {172, 170, 223, 178}, {230, 181, 277, 198}, {308, 232, 328, 264}, {64, 199, 78, 219}
				}

	boss.quad = {}
	boss.warts = {}

	boss.explode = {}

	boss.explode.img = LG.newImage("img/explode_boss_complete.png")
	boss.explode.quad = {}

	for i = 0, 9 do
		table.insert(boss.quad, LG.newQuad(i*400, 0, 400, 300, 4000, 300))
	end

	for i = 0, 5 do
		table.insert(boss.explode.quad, LG.newQuad(i*500, 0, 500, 310, 3000, 310))
	end

	for i=1, 9 do
		table.insert(boss.warts, LG.newImage("img/boss/wart/"..i..".png"))
	end

	boss.time = timer.newTime()
	boss.time2 = 0
	boss.setTime = false
end

function boss.update(dt)
	boss.y = boss.y + 0.1*math.sin(timer.get(boss.time))

	if player.y >= 11300 then boss.start = true else boss.start = false end

	if #boss.warts > 0 then
		-- colision
		for i,v in ipairs(boss.hitbox) do
			for j,k in ipairs(v) do
				if col.isAinB(player.x, player.y, k[1] + boss.x, k[2] + boss.y, k[3] + boss.x, k[4] + boss.y) then
					player.collisionMove(dt, {x=k[1], y=k[2], n = 9, w = boss.warts[i]:getWidth(), h = boss.warts[i]:getHeight()}, i, true)
					collide = true
					sounds.drill:play()
				end
			end
		end

		for j,k in ipairs(boss.box) do
			if col.isAinB(player.x, player.y, k[1] + boss.x, k[2] + boss.y, k[3] + boss.x, k[4] + boss.y) then
				player.move(-2*dt)
				player.sx = 0.5*player.maxsx
				player.sy = 0.5*player.maxsy
				sounds.drill:play()
			end
		end
	end
end

function boss.draw()
	if #boss.warts > 0 then
		local index = math.floor(5*timer.get(boss.time)%3 + 1)
		LG.draw(boss.img, boss.quad[1], boss.x, boss.y)
		for i,v in ipairs(boss.warts) do
			LG.draw(v, boss.x, boss.y)
		end
	elseif #boss.warts == 0 and not boss.dead then
		if not boss.setTime then
			boss.time2 = timer.newTime()
			boss.setTime = true
		end
		local index = math.floor(4*timer.get(boss.time2)%6 + 1)
		LG.draw(boss.explode.img, boss.explode.quad[index], boss.x, boss.y + 30)

		if index == 1 and timer.get(boss.time2) > 1 then
			boss.dead = true
		end
	end
end