shop = {}

function shop.load()
	shop.img = LG.newImage("img/shop_window.png")
	shop.objects = {
						-- Drills
						{
							img = LG.newImage("img/shop/drill_1.png"),
							price = 5,
							descr = "A stainless steel drill, perfect for the average miner \n Grab it while it's hot!\nDrill time*0.8, cost = 5g",
							x = 19, y = 26,
							l = 1, -- layer
							t = "drill" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/drill_2.png"),
							price = 17,
							descr = "Iron drill! Go beneath the surface in seconds!\n Deal of the day!\nDrill time*0.6, cost = 17g",
							x = 19, y = 26,
							l = 2, -- layer
							t = "drill" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/drill_3.png"),
							price = 40,
							descr = "Gold drill! Take this shiny thing and show off!\n It's the coolest thing on earth!\nDrill time*0.4, cost = 40g",
							x = 19, y = 26,
							l = 3, -- layer
							t = "drill" -- type. If this type is gone, open next layer of this type
						},
						-- Tanks
						{
							img = LG.newImage("img/shop/tank_1.png"),
							price = 10,
							descr = "Big ass tank!\n Dig deeper mate!\nCapacity*1.5, cost = 10g",
							x = 140, y = 26,
							l = 1, -- layer
							t = "tank" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/tank_2.png"),
							price = 32,
							descr = "This shit's from outer space man!\n Nowhere to go but down!\nCapacity*1.75, cost = 32g",
							x = 140, y = 26,
							l = 2, -- layer
							t = "tank" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/tank_3.png"),
							price = 70,
							descr = "Don't know what this thing is burning, but it ain't bad!\n Haha, I'm not touching it..\nCapacity*2, cost = 70g",
							x = 140, y = 26,
							l = 3, -- layer
							t = "tank" -- type. If this type is gone, open next layer of this type
						},
						--Lights
						{
							img = LG.newImage("img/shop/light_1.png"),
							price = 18,
							descr = "Getting dark down there? Take this with you\n It's gonna keep you your eyes open!\n+ Light source, cost = 18g",
							x = 261, y = 26,
							l = 1, -- layer
							t = "light" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/light_2.png"),
							price = 40,
							descr = "Lumos Maxima!\n  Yer a wizard 'arry..\nFind it out...?, cost = 40g",
							x = 261, y = 26,
							l = 2, -- layer
							t = "light" -- type. If this type is gone, open next layer of this type
						},
						--Power
						{
							img = LG.newImage("img/shop/power_1.png"),
							price = 10,
							descr = "Too slow? Powaaaaah\n Hadouken!\nSpeed*1.3, cost = 10g",
							x = 382, y = 26,
							l = 1, -- layer
							t = "power" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/power_2.png"),
							price = 25,
							descr = "Faster than a couger (no offense).\n  Swoosh\nSpeed*1.6, cost = 25g",
							x = 382, y = 26,
							l = 2, -- layer
							t = "power" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/power_3.png"),
							price = 25,
							descr = "Where are you?.\n Seriously though, this shit's fast.\nSpeed*2, cost = 45g",
							x = 382, y = 26,
							l = 3, -- layer
							t = "power" -- type. If this type is gone, open next layer of this type
						},
						{
							img = LG.newImage("img/shop/brakes.png"),
							price = 5,
							descr = "Ship too fast? Hold [space] to break\n Really useful for mining.\n+ brakes cost = 5g",
							x = 19, y = 159,
							l = 1, -- layer
							t = "brakes" -- type. If this type is gone, open next layer of this type
						},
}
	shop.open = false
	shop.time = 0
	shop.buytime = 0

	minLevel = {} -- has entries {t = "drill", l = 1}
end

function shop.update(dt)
	if shop.open then
		shop.time = shop.time + dt

		shop.buytime = shop.buytime + dt

		-- Lets buy some stuff
		for i,v in ipairs(shop.objects) do
			for j,k in ipairs(minLevel) do
				if k.t == v.t and k.l == v.l then
					if LM.isDown("l") then -- isclick
						if col.isAinB(love.mouse.getX()/2, love.mouse.getY()/2, v.x, v.y, v.x+95, v.y+121) then --isinwindow
							if gui.coin.n >= v.price then
								if shop.buytime > 0.5 then
									gui.coin.n = gui.coin.n - v.price
									table.insert(inventory, v.t .. "_" .. v.l)
									table.remove(shop.objects, i)
									table.remove(minLevel, j)
									shop.buytime = 0
								end
							end
						end
					end
				end
			end
		end

	end
end

function shop.draw()
	if shop.open then
		gui.doDraw = false

		LG.setColor(120,120,120,160)
		LG.rectangle("fill", 0, 0, 640, 382)
		LG.setColor(255,255,255,255)
		LG.draw(shop.img, 0, 0)

		-- compute minLevel table
		for i,v in ipairs(shop.objects) do
			if isInTable(minLevel, v.t, "drill") then
				for j,k in ipairs(minLevel) do
					if k.t == v.t then
						--only if he doesnt have it!
						if not player.has(v.t .. "_" .. v.l) then
							if v.l < k.l then
								table.remove(minLevel, j)
								table.insert(minLevel, {t = v.t, l = v.l})
							end
						end
					end
				end
			else
				--only if he doesnt have it!
				if not player.has(v.t .. "_" .. v.l) then
					table.insert(minLevel, {t = v.t, l = v.l})
				end
			end
		end

		-- draw the objects + description
		for i,v in ipairs(shop.objects) do
			if not player.has(v.t .. "_" .. v.l) then
				for j,k in ipairs(minLevel) do
					if k.t == v.t and k.l == v.l then
						--draw it!
						LG.draw(v.img, v.x, v.y)
						if col.isAinB(love.mouse.getX()/2, love.mouse.getY()/2, v.x, v.y, v.x+95, v.y+121) then
							LG.print(v.descr, 14, 299)
						end
					end
				end
			end
		end

		-- Draw your money
		LG.draw(gui.coin.img, 540,310)
		LG.print("x "..gui.coin.n, 557,307)
	else
		gui.doDraw = true
	end
end

function shop.keypressed(key)
	if key == "b" and shop.time > 0.1 then
		shop.open = false
		shop.time = 0
	end
end