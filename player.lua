player = {}
inventory = { }

function player.has( item )
	for i,v in ipairs(inventory) do
		if v == item then
			return true
		end
	end

	return false
end

function player.load()
	player.time = 0
	player.time2 = 0
	timecollide = 0

	player.x = 140
	player.y = 63 --63
	player.r = 204

	player.sx = 50 --speed
	player.sy = 30
	player.maxsx = 200
	player.maxsy = 200 -- 300
	player.ax = 100 -- acceleration
	player.ay = 100

	player.dir = -1 -- direction

	player.w = 25
	player.h = 50

	player.jx = 0 --jetpack spawn coordinates
	player.jy = 0

	player.cx = 0 -- collision position
	player.cy = 0
	player.cr = 20 -- collision radius

	player.radius = 20

	player.path = {}

	player.img = LG.newImage("img/rocket.png") -- we start with a rocket...
	player.img:setFilter("nearest", "nearest")
	player.quad = { LG.newQuad(0,0,20,40,60,40),
					LG.newQuad(20,0,20,40,60,40),
					LG.newQuad(40,0,20,40,60,40)
				}
	player.currentQuad = 1

	player.rocket = {}
	player.rocket.img = LG.newImage("img/rocket.png")

	player.state = "idle" -- idle, moving, attacking (?)

	-- items and stuff i guess?
	player.drillfactor = 1
	player.tankfactor = 1
	player.lightfactor = 1
	player.speedfactor = 1

	-- did he get pulled up?
	player.pay = false
end

function player.move( dt )
	player.x = player.x - math.sin(math.rad(player.r))*player.sx*dt
	player.y = player.y + math.cos(math.rad(player.r))*player.sy*dt
end

function player.update(dt)
	player.time = player.time + dt
	player.time2 = player.time2 + dt

	if player.r > 180 then
		player.r = player.r - 360
	elseif player.r < -180 then
		player.r = player.r + 360
	end

	if player.r < -90 or player.r > 90 then
		player.dir = -1
	else
		player.dir = 1
	end

	if player.time > 0.03 then
		player.time = 0
		player.currentQuad = player.currentQuad + 1
		if player.currentQuad > 3 then
			player.currentQuad = 1
		end
	end

	if startoff and player.state == "idle" then
		player.sx = player.sx + player.ax*dt
		player.sy = player.sy + player.ay*dt

		player.r = player.r + player.sx*dt
		
		player.move(dt)

		if player.r >= 0 then
			player.r = 0
			player.state = "moving"
		end
	end

	if player.state == "moving" and startoff then
		sounds.drill:pause()

		if gui.fuel.n > 0 then
			player.sx = math.min(player.sx + player.ax*dt, player.maxsx*player.speedfactor)
			player.sy = math.min(player.sy + player.ay*dt, player.maxsy*player.speedfactor)
		else
			player.sx = math.max(player.sx - player.ax*dt, 0)
			player.sy = math.max(player.sy - player.ay*dt, 0)
			if player.sx == 0 or player.sy == 0 then
				player.state = "pull"
				player.pay = true
			end
		end

		if LK.isDown("left") then
			player.r = player.r - 150*dt
			-- if player.r <= -60 then player.r = -60 end
		elseif LK.isDown("right") then
			player.r = player.r + 150*dt
			-- if player.r >= 60 then player.r = 60 end
		end

		if LK.isDown(" ") and player.has("brakes_1") then
			player.sx = 0.8*player.sx
			player.sy = 0.8*player.sy
		end

		player.move( dt )

		table.insert(player.path, player.x)
		table.insert(player.path, player.y)

		-- does he collect fuel?
		for i,v in ipairs(world.objects.fuel) do
			if col.isAinB(player.x-6, player.y, v.x, v.y, v.x+22, v.y+22) then
				table.remove(world.objects.fuel, i)
				gui.fuel.n = gui.fuel.n + 30
			elseif col.isAinB(player.x+6, player.y, v.x, v.y, v.x+22, v.y+22) then
				table.remove(world.objects.fuel, i)
				gui.fuel.n = gui.fuel.n + 30
			end
		end

		-- does he collect coins?
		for i,v in ipairs(world.objects.coins) do
			if col.isAinB(player.x-9, player.y, v.x, v.y, v.x+12, v.y+12) then
				table.remove(world.objects.coins, i)
				gui.coin.nt = gui.coin.nt + 1
			elseif col.isAinB(player.x+9, player.y, v.x, v.y, v.x+12, v.y+12) then
				table.remove(world.objects.coins, i)
				gui.coin.nt = gui.coin.nt + 1
			elseif col.isAinB(player.x, player.y, v.x, v.y, v.x+12, v.y+12) then
				table.remove(world.objects.coins, i)
				gui.coin.nt = gui.coin.nt + 1
			end
		end

		-- does he collide with the "holes"?
		for i,v in ipairs(world.objects.randomHoles) do
			for j=1, #world.cobjects.randomHoles[v.n] do
				local collide = false
				k = world.cobjects.randomHoles[v.n][j]
				if world.objects.randomHoles[i] == nil then tx, ty = 0, 0 else
					tx = world.objects.randomHoles[i].x or 0
					ty = world.objects.randomHoles[i].y or 0
				end
				if tx < player.x then
					if col.isAinB(player.x+6, player.y, k[1]+tx, k[2]+ty, k[3]+tx, k[4]+ty) then
						player.collisionMove(dt, v, i)
						collide = true
						sounds.drill:play()
					end
					if col.isAinB(player.x-6, player.y, k[1]+tx, k[2]+ty, k[3]+tx, k[4]+ty) then
						player.collisionMove(dt, v, i)
						collide = true
						sounds.drill:play()
					end
				end
			end
		end

		-- does he collide with the floor?
		if col.isAinB(player.x+6, player.y, -100000, 11730, 100000, 11780) then
			player.collisionMove(dt, {n = 100}, 0, true)
			collide = true
			sounds.drill:play()
		end
		if col.isAinB(player.x-6, player.y, -100000, 11730, 100000, 11780) then
			player.collisionMove(dt, {n = 100}, 0, true)
			collide = true
			sounds.drill:play()
		end

		print(player.y)

		-- player to the ground!
		if player.y <= 100 and player.dir == -1 then
			player.state = "finished"
		end
	end

	if player.state == "jetpack" then
		player.jetpackUpdate(dt)
	end

	if player.state == "finished" then
		effects.finished(dt)
	end

	if player.state == "pull" then
		effects.pull(dt)
		if player.y <= 100 then
			player.state = "finished"
		end
	end

	if player.state == "finished" and LK.isDown("return") then
		world.load()
		startoff = false
		gui.fuel.n = 100
		player.load()
	end
end

function player.spawnCoin(n, v)
	for i=1, n do
		local x1 = v.x
		local y1 = v.y
		local x2 = v.x + v.w
		local y2 = v.y + v.h
		local coinx = math.random(x1, x2)
		local coiny = math.random(y1, y2)

		table.insert(world.objects.coins, {x = coinx, y = coiny})
	end
end

function player.collisionMove(dt, stone, i, doboss)
	timecollide = timecollide + dt
	mineral = stone.n

	if not doboss then
		effects.shake(dt, stone)
	end

	if mineral == 5 then -- Diamonds
		if timecollide >= 8*player.drillfactor then
			timecollide = 0
			player.spawnCoin(17, stone)
			if love.math.random(0, 1) == 0 then
				xt = world.objects.randomHoles[i].x
				yt = world.objects.randomHoles[i].y
				table.insert(world.objects.fuel, {x = xt, y = yt})
			end
			table.remove(world.objects.randomHoles, i)
			table.insert(world.objects.explode.object, {x = stone.x-stone.w/2, y = stone.y-stone.h/2, t = timer.newTime()})
			sounds.explode:play()
		end
	end
	if mineral == 6 then -- Ruby
		if timecollide >= 7*player.drillfactor then
			timecollide = 0
			player.spawnCoin(13, stone)
			if love.math.random(0, 2) == 0 then
				xt = world.objects.randomHoles[i].x
				yt = world.objects.randomHoles[i].y
				table.insert(world.objects.fuel, {x = xt, y = yt})
			end
			table.remove(world.objects.randomHoles, i)
			table.insert(world.objects.explode.object, {x = stone.x-stone.w/2, y = stone.y-stone.h/2, t = timer.newTime()})
			sounds.explode:play()
		end
	end
	if mineral == 7 then -- Coal
		if timecollide >= 5*player.drillfactor then
			timecollide = 0,
			player.spawnCoin(2, stone)
			if love.math.random(0, 3) == 0 then
				xt = world.objects.randomHoles[i].x
				yt = world.objects.randomHoles[i].y
				table.insert(world.objects.fuel, {x = xt, y = yt})
			end
			table.remove(world.objects.randomHoles, i)
			table.insert(world.objects.explode.object, {x = stone.x-stone.w/2, y = stone.y-stone.h/2, t = timer.newTime()})
			sounds.explode:play()
		end
	end
	if mineral == 8 then -- Gold
		if timecollide >= 4*player.drillfactor then
			timecollide = 0
			player.spawnCoin(7, stone)
			if love.math.random(0, 2) == 0 then
				xt = world.objects.randomHoles[i].x
				yt = world.objects.randomHoles[i].y
				table.insert(world.objects.fuel, {x = xt, y = yt})
			end
			table.remove(world.objects.randomHoles, i)
			table.insert(world.objects.explode.object, {x = stone.x-stone.w/2, y = stone.y-stone.h/2, t = timer.newTime()})
			sounds.explode:play()
		end
	end
	if mineral <= 4 then --stone
		if timecollide >= 3*player.drillfactor then
			timecollide = 0
			player.spawnCoin(1, stone)
			if love.math.random(0, 3) == 0 then
				xt = world.objects.randomHoles[i].x
				yt = world.objects.randomHoles[i].y
				table.insert(world.objects.fuel, {x = xt, y = yt})
			end
			table.remove(world.objects.randomHoles, i)
			print("noew")
			table.insert(world.objects.explode.object, {x = stone.x-stone.w/2, y = stone.y-stone.h/2, t = timer.newTime()})
			sounds.explode:play()
		end
	end
	if mineral == 100 then

	elseif doboss then
		if timecollide >= 20*player.drillfactor then
			timecollide = 0
			print(stone.x, stone.y, stone.n)
			table.remove(boss.hitbox, i)
			table.remove(boss.warts, i)
			table.insert(world.objects.explode.object, {x = stone.x-stone.w/2, y = stone.y-stone.h/2, t = timer.newTime(), b = true})
			sounds.explode:play()
		end
	end
	
	player.move(-dt)
	player.sx = 0.5*player.maxsx
	player.sy = 0.5*player.maxsy

	if player.cx == 0 and player.cy == 0 then
		player.cx = player.x
		player.cy = player.y
	end

	if math.sqrt((player.cx - player.x)^2 + (player.cy - player.y)^2) > player.cr then
		player.cx = 0
		player.cy = 0
	end
end

function player.draw()
		LG.setBlendMode("subtractive")
		LG.setColor(0,0,0,255)
		for i=0, 1000 do
			if i%2 == 0 and i ~= 0 and #player.path > i then
				LG.circle("fill", player.path[#player.path-i-1] - 3, player.path[#player.path-i], 20)
			end
		end

		if player.state ~= "pull" then
			LG.setBlendMode("subtractive")
			LG.circle("fill", player.x - 3, player.y, player.radius)
		end
		LG.setBlendMode("alpha")
		LG.setColor(255,255,255)

		if player.state ~= "finished" then
			LG.draw(player.img, player.quad[player.currentQuad], player.x, player.y, math.rad(player.r), 1, 1, player.w/2, 2*player.h/3)
		else
			effects.finished()
			LG.draw(player.img, player.quad[1], player.x, 69, math.rad(180), 1, 1, player.w/2, 2*player.h/3)
		end

		if player.state == "pull" then
			effects.pull()

			if love.keyboard.isDown(" ") then
				player.y = 130
			end
		end

end

function player.keypressed(key)
	-- if key == "e" and player.state == "moving" then
	-- 	player.state = "jetpack"
	-- 	player.jx = player.x
	-- 	player.jy = player.y

	-- 	player.sx = 0
	-- 	player.sy = 0
	-- end
end