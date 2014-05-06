cam = {}
cam.x = 0
cam.y = 0

function cam.update(dt)
	if player.state == "idle" then
		if cam.y > -50 then
			cam.y = cam.y - 50*dt
		elseif cam.y < -55 then
			cam.y = cam.y + 50*dt
		end
	elseif player.state == "moving" then
		if boss.start then
			if cam.y < 11350 then
				cam.y = cam.y + math.abs(cam.y - (player.y + 50))*2.5*dt
			else
			cam.y = 11350

			end
		else
			local dif = 0
			if player.dir == 1 then
				dif = -60
			else
				dif = -310
			end
			if cam.y >= player.y + dif then
				cam.y = cam.y - math.abs(cam.y - (player.y + dif))*2.5*dt
			else
				cam.y = cam.y + math.abs(cam.y - (player.y + dif))*2.5*dt
			end
		end
	elseif player.state == "finished" then
		if cam.y > -50 then
			cam.y = cam.y - math.abs(cam.y - (player.y - 150))*2.5*dt
		elseif cam.y < -55 then
			cam.y = math.abs(cam.y - (player.y - 150))*2.5*dt
		end
	elseif player.state == "pull" then
		if cam.y >= player.y - 350 then
			cam.y = cam.y - math.abs(cam.y - (player.y - 350))*2.5*dt
		end
	end
end