world = {}

function world.load()
	world.layer = 1 -- root

	-- Images
	world.images = {}

	-- objects
	world.objects = {}	

	-- collision objects
	world.cobjects = {}

	-- bubbles
	world.images.space = LG.newImage("img/space.png")
	world.images.three = LG.newImage("img/3.png")
	world.images.two = LG.newImage("img/2.png")
	world.images.one = LG.newImage("img/1.png")
	world.images.b = LG.newImage("img/b.png")

	-- normal stuff
	world.images.bg = LG.newImage("img/bg.png")
	world.images.flower = LG.newImage("img/flower.png")
	world.images.startPlatform = LG.newImage("img/startPlatform.png")
	world.images.fuel = LG.newImage("img/fuel_pu.png")
	world.images.shop = LG.newImage("img/shop.png")

	-- random holes
	world.images.randomHoles = {
								LG.newImage("img/random/1.png"),
								LG.newImage("img/random/2.png"),
								LG.newImage("img/random/3.png"),
								LG.newImage("img/random/4.png"),
								LG.newImage("img/random/5.png"), --diamonds
								LG.newImage("img/random/6.png"), --ruby
								LG.newImage("img/random/7.png"), --coal
								LG.newImage("img/random/8.png"), --gold
	}

	-- random holes as object
	world.objects.randomHoles = {} -- they will have entries like {x,y,img}

	-- random holes to collide with
	world.cobjects.randomHoles = {}
	world.cobjects.randomHoles[1] = {{0,0,30,31}, {31,0,40,23}, {41,4,52,24}}
	world.cobjects.randomHoles[2] = {{0,0,68,53}}
	world.cobjects.randomHoles[3] = {{0,0,37,53}, {38,2,48,37}, {49,4,54,31}}
	world.cobjects.randomHoles[4] = {{0,5,31,18}}
	world.cobjects.randomHoles[5] = {{0,10,6,23}, {7,0,22,30}, {21,5,29,23}}
	world.cobjects.randomHoles[6] = {{0,0,24,24}, {24,7,38,24}}
	world.cobjects.randomHoles[7] = {{0,0,38,37}}
	world.cobjects.randomHoles[8] = {{0,0,52,27}}

	-- Textures
	world.images.texturesbg = {		LG.newImage("img/l1_tex.png"), --naming convention: l[layer number where the texture starts]_tex.png
									LG.newImage("img/l1_tex.png"),
									LG.newImage("img/l2_tex.png"),
									LG.newImage("img/l2_tex.png"),
									LG.newImage("img/l2_tex.png"),
									LG.newImage("img/l7_tex.png"),
									LG.newImage("img/l7_tex.png"),
									LG.newImage("img/l10_tex.png"),
									LG.newImage("img/l10_tex.png"),
									LG.newImage("img/l10_tex.png"),
									LG.newImage("img/l10_tex.png"),
									LG.newImage("img/l10_tex.png"),
									LG.newImage("img/l10_tex.png"),
									LG.newImage("img/l10_tex.png"),
								}

	-- Fuel
	world.objects.fuel = {}

	-- coins
	world.objects.coins = {}

	-- explode
	world.objects.explode = {}
	world.objects.explode.img = LG.newImage("img/explode.png")
	world.objects.explode.img2 = LG.newImage("img/explode_boss.png")
	world.objects.explode.quad = {	LG.newQuad(0, 0, 50, 31, 300, 31),
									LG.newQuad(50, 0, 50, 31, 300, 31),
									LG.newQuad(100, 0, 50, 31, 300, 31),
									LG.newQuad(150, 0, 50, 31, 300, 31),
									LG.newQuad(200, 0, 50, 31, 300, 31),
									LG.newQuad(250, 0, 50, 31, 300, 31)
									}
	world.objects.explode.object = {}

	world.colors = {
						{0, 116, 27, 240},
						{0, 141, 33, 240},
						{123, 79, 49, 240},
						{94, 57, 27, 240},
						{73, 48, 27, 240},
						{70, 43, 34, 240},
						{69, 39, 39, 240},
						{60, 21, 60, 240},
						{55, 10, 37, 240},
						{55, 10, 37, 240},
						{55, 10, 37, 240},
						{55, 10, 37, 240},
						{55, 10, 37, 240},
						{55, 10, 37, 240},
						{55, 10, 37, 240}
					}

	world.layers = {}
	world.layers.y = {} -- the y position of the layer where i from WL[i] is the layer
	world.layers.h = {} -- the height ... blahblah


	WC = world.colors
	WI = world.images
	WL = world.layers

	world.countdown = 4 -- at 0 means startoff!


	world.flowerpos = {}
	for i = 1, 21 do
		world.flowerpos[i] = love.math.random(0, 64)*i
	end

	for i in ipairs(WC) do
		world.layers.y[i] = (world.layers.y[i-1] or 100) + math.min(math.exp(i)^2, 1500)
		world.layers.h[i] = math.min(math.exp(i)^2, 1500)
	end

	world.computeRandomHoles()
	world.computeFuel()
end

function world.level()
	-- each layer is max(exp(layernum)^2, const) high

	local height = 100
	local thickness = 0

	-- needed for blending in the alpha
	LG.push()

	for i, color in ipairs(WC) do
		LG.setColor(color or {255,255,255, 200})
			thickness = math.min(math.exp(i)^2, 1500)
			LG.rectangle("fill", 0, height, 768, thickness )
		LG.setColor(255,255,255)

		height = (world.layers.y[i-1] or 100) + thickness
	end

	LG.setColor(255,255,255,255)

	LG.pop()

	if player.y >= (world.layers.y[world.layer] or 0) then
		world.layer = world.layer + 1
	end
end

function world.backgroundTexture()
	-- the background comes first
	LG.draw(WI.bg, 0, 0)
	
	local i = 1
	for _,v in pairs(world.images.texturesbg) do
		for j=0, 11 do -- x direction
			for k=0, math.ceil( (world.layers.h[i] or 0) / 30) do
				LG.draw(world.images.texturesbg[i], j*60, k*30 + (world.layers.y[i-1] or 100))
			end
		end
		LG.setBlendMode("subtractive")
		LG.setColor(0,0,0,255)
		LG.rectangle("fill", 0, world.layers.y[i], 640, 60)
		LG.setBlendMode("alpha")
		LG.setColor(255,255,255)
		i = i + 1
	end
end

function world.computeRandomHoles()
	for i in ipairs(WC) do
		if i > 1 then
			world.genHoles(love.math.random(3, math.min(2*i+1, 6)), i, 1, 4)

			if i >= 3 then
				world.genHoles(love.math.random(0, love.math.random(2,math.max(2, 4 - math.floor((i - 3)*0.7))) ), i, 7, 7) -- coal
			end

			if i >= 4 then
				world.genHoles(love.math.random(0, love.math.random(1,math.max(1, 3 - math.floor((i - 3)*0.7))) ), i, 8, 8) -- gold
			end

			if i >= 5 then
				world.genHoles(love.math.random(0, love.math.random(0,math.max(0, 4 - math.floor((i - 3)*0.7))) ), i, 6, 6) -- ruby
			end

			if i >= 6 then
				world.genHoles(love.math.random(0, love.math.random(0,math.max(0, 1 - math.floor((i - 3)*0.7))) ), i, 5, 5) -- diamond
			end
		end
	end
end

function world.genHoles(num, i, t1, t2)
	for j=0, num do
		local xt = love.math.random(0, 440)
		local yt = love.math.random(world.layers.y[i], world.layers.y[i]+world.layers.h[i])
		
		if yt <= 11100 then
			for l=0,6 do
				love.math.random()
			end
			local t = love.math.random(t1, t2)
			local imgt = world.images.randomHoles[t]
			table.insert(world.objects.randomHoles, {x = xt, y = yt, img = imgt, n = t, w = imgt:getWidth(), h = imgt:getHeight(), d = 1})
		end
	end
end

function world.drawRandomHoles()
	-- LG.setBlendMode("subtractive")
	for i,v in ipairs(world.objects.randomHoles) do
		LG.draw(v.img, v.x, v.y)
	end
	-- LG.setBlendMode("alpha")
end

function world.drawExplosion()
	local img = world.objects.explode.img
	local img2 = world.objects.explode.img2
	local quad = world.objects.explode.quad
	for i,v in ipairs(world.objects.explode.object) do
		local index = math.floor(10*timer.get(v.t)%6 + 1)

		print(10*timer.get(v.t)%6 + 1)
		if v.b then
			LG.draw(img2, quad[index], v.x+img:getWidth()/12, v.y+img:getHeight()/2)
		else
			LG.draw(img, quad[index], v.x+img:getWidth()/12, v.y+img:getHeight()/2)
		end

		if index >= 6 then
			table.remove(world.objects.explode.object, i)
		end
	end
end

function world.computeFuel()
	for i in ipairs(WC) do
		if i > 2 then
			-- 1 fuel per level, so....
			local xt = love.math.random(10, 630)
			local yt = love.math.random(world.layers.y[i], world.layers.y[i]+world.layers.h[i])
			table.insert(world.objects.fuel, {x = xt, y = yt})
		end
	end
end

function world.drawFuel()
	for i,v in ipairs(world.objects.fuel) do
		LG.draw(world.images.fuel, v.x, v.y)
	end
end

function world.drawCoins()
	for i,v in ipairs(world.objects.coins) do
		LG.draw(gui.coin.img, v.x, v.y)
	end
end

function world.update(dt)
	if LK.isDown(" ") and not shop.open then
		if world.countdown == 4 then world.countdown = 3 end
	end

	if LK.isDown("escape") and world.countdown > 0 then
		world.countdown = 4
	end

	if world.countdown <= 3 then
		world.countdown = world.countdown - 1.5*dt
	end
end

function world.draw()
	-- draw 20 flowers
	for i = 1, 21 do 
		LG.draw(WI.flower, world.flowerpos[i], 96)
	end

	-- the bubbles
	if world.countdown == 4 then
		LG.draw(WI.space, 160, 50)
	elseif world.countdown >= 2 then
		LG.draw(WI.three, 160, 50)
	elseif world.countdown >= 1 then
		LG.draw(WI.two, 160, 50)
	elseif world.countdown >= 0 then
		LG.draw(WI.one, 160, 50)
	else
		startoff = true
	end

	-- draw the level
	world.level()

	LG.draw(WI.startPlatform, 110, 75)
end

function world.keypressed(key)
	if key == "b" and world.countdown == 4 then
		shop.open = true
	end
end