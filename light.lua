light = {}

function light.load()
	light.darkness = 0
end

function light.update(dt)
	light.darkness = math.min(player.y/math.exp(3), 250)
end

function light.draw()

	LG.setColor(0,0,0,light.darkness*player.lightfactor)
	LG.rectangle("fill", 0, cam.y - player.y - 100, 1280, 868)

	-- the light
	if player.has("light_1") then
		LG.setColor(0,0,0,80)
		LG.setBlendMode("subtractive")
		for i=0,6 do
			LG.circle("fill", player.x, player.y - cam.y, 50 + 10*i)
		end
		LG.setBlendMode("alpha")
	end
	LG.setColor(255,255,255,255)
end