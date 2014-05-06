effects = {}

function effects.load()
	t0 = 1 -- pull
	t1 = 0
end

function effects.update(dt)

end

function effects.draw()

end

function effects.finished(dt)
	if dt == nil then -- draw
		LG.setColor(255,255,255)
		LG.setFont(deffontBig)
		LG.print("Finished! Press return to continue!", 150, -10, 0, 1)
		LG.setFont(deffont)
	else

	end
end

function effects.pull(dt)
	if dt == nil then --draw
		LG.line(player.x, 100, player.x, math.min(player.y-(math.min(360, player.y-100)-100*t0), player.y))
	else
		t0 = t0 + dt

		if math.min(player.y-(math.min(360, player.y-100)-100*t0), player.y) >= player.y - 4 then
			t1 = t1 + dt

			if player.r < 0 then
				player.r = math.max(player.r - 200*dt, -180)
			else
				player.r = math.min(player.r + 200*dt, 180)
			end

			if math.abs(player.r) == 180 then
				player.y = player.y - 400*dt
			end
		end
	end
end

function effects.shake(dt, object)
	object.x = object.x - dt*sign(object.d)*200
	object.d = -object.d
end