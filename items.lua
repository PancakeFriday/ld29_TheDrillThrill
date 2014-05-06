items = {}

function items.update()
	if player.has("drill_1") then
		player.drillfactor = 0.7
	end
	if player.has("drill_2") then
		player.drillfactor = 0.4
	end
	if player.has("drill_3") then
		player.drillfactor = 0.2
	end
	if player.has("tank_1") then
		player.tankfactor = 0.7
	end
	if player.has("tank_2") then
		player.tankfactor = 0.5
	end
	if player.has("tank_3") then
		player.tankfactor = 0.3
	end
	if player.has("light_1") then

	end
	if player.has("light_2") then
		player.lightfactor = 0.75
	end
	if player.has("power_1") then
		player.speedfactor = 1.3
	end
	if player.has("power_2") then
		player.speedfactor = 1.7
	end
	if player.has("power_3") then
		player.speedfactor = 2
	end

end
