-- Makros
LG = love.graphics
LK = love.keyboard
LM = love.mouse
LA = love.audio

-- requires
require "boss"
require "camera"
require "collision"
require "effects"
require "gui"
require "items"
require "light"
require "maths"
require "player"
require "shop"
require "sounds"
require "timer"
-- require "jetpack"
require "world"

function love.load()
	LG.setDefaultFilter("nearest","nearest")
	deffont = LG.newFont("fonts/Minecraftia.ttf", 11)
	deffontBig = LG.newFont("fonts/Minecraftia.ttf", 20)
	LG.setFont(deffont)

	-- FPS cap
	min_dt = 1/60
	next_time = love.timer.getTime()

	-- Enums
	DEV_MODE = false
	GAMEOVER = false

	-- Random generation
	love.math.setRandomSeed(os.time())
	for i=1, 6 do love.math.random() end

	-- Canvas stuff
	canvas = LG.newCanvas(640, 384*2) -- our dimensions are actually 640 x 384
	canvas:setFilter("nearest", "nearest")

	bgCanvas = LG.newCanvas(640, 384*2)
	bgCanvas:setFilter("nearest", "nearest")

	guiCanvas = LG.newCanvas(640, 384*2)
	guiCanvas:setFilter("nearest", "nearest")

	objCanvas = LG.newCanvas(640, 384*2)
	objCanvas:setFilter("nearest", "nearest")

	lightCanvas = LG.newCanvas(640, 384*2)
	guiCanvas:setFilter("nearest", "nearest")


	-- Important stuff
	startoff = false

	boss.load()
	effects.load()
	world.load()
	player.load()
	shop.load()
	-- player.jetpackLoad()
	gui.load()

	for i,v in pairs(sounds) do
		v:setVolume(0.4)
		print("yes")
	end
end

function love.update(dt)
	-- FPS cap
	next_time = next_time + min_dt

	if DEV_MODE then
		if LK.isDown("i") then
			player.y = player.y - 300*dt
		end
		if LK.isDown("j") then
			player.x = player.x - 300*dt
		end
		if LK.isDown("k") then
			player.y = player.y + 900*dt
		end
		if LK.isDown("l") then
			player.x = player.x + 300*dt
		end

		if LK.isDown("g") then
			gui.coin.n = gui.coin.n + 1
		end
		if LK.isDown("f") then
			gui.fuel.n = 0
		end
		if LK.isDown("p") then
			for i,v in ipairs(boss.warts) do
				table.remove(boss.warts, i)
			end
		end
		if LK.isDown("d") then
			player.drillfactor = 0.1
		end
	end

	if not GAMEOVER then
		-- Other stuff
		timer.update(dt)
		cam.update(dt)
		world.update(dt)
		items.update()
		player.update(dt)
		boss.update(dt)
		light.update(dt)
		gui.update(dt)
		shop.update(dt)
	end
end

function love.draw()
	LG.setBackgroundColor(0, 174, 255)

	LG.setCanvas(bgCanvas)
	-- Draw the background stuff
		LG.push()
		LG.translate(0, -cam.y)
		world.backgroundTexture()
		LG.pop()

	LG.setCanvas(canvas)
	-- Draw most of the stuff
		LG.push()
		LG.translate(0, -cam.y)
		world.draw()
		player.draw()
		LG.pop()

	LG.setCanvas(guiCanvas)
		gui.draw()
		shop.draw()

	LG.setCanvas(objCanvas)
		LG.push()		
		LG.translate(0, -cam.y)

		-- draw the shop
		LG.draw(WI.shop, 400, 53)
		if not startoff then
			LG.draw(WI.b, 440, 50)
		end

		world.drawFuel()
		world.drawRandomHoles()
		world.drawExplosion()
		world.drawCoins()
		boss.draw()
		LG.pop()

	LG.setCanvas(lightCanvas)
		light.draw()

	LG.setCanvas()

	LG.draw(bgCanvas, 0, 0, 0, 2, 2)
	LG.draw(canvas, 0, 0, 0, 2, 2)
	LG.draw(objCanvas, 0, 0, 0, 2, 2)
	LG.draw(lightCanvas, 0, 0, 0, 2, 2)
	LG.draw(guiCanvas, 0, 0, 0, 2, 2)

	bgCanvas:clear()
	canvas:clear()
	objCanvas:clear()
	guiCanvas:clear()
	lightCanvas:clear()

	-- FPS cap
	-- love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end

function love.keypressed( key, isrepeat )
	if key == "r" then
		love.load()
	end
	if key == "t" then
		GAMEOVER = false
		gui.fuel.n = 100
	end

	gui.keypressed(key)
	player.keypressed(key)
	world.keypressed(key)
	shop.keypressed(key)
end

function love.mousepressed( x, y, button )

end