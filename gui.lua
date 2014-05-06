gui = {}

function gui.load()
	gui.doDraw = true

	gui.fuel = {}
	gui.fuel.img = LG.newImage("img/fuel_pu.png")
	gui.fuel.n = 100

	gui.eject = {}
	gui.eject.img = LG.newImage("img/eject.png")

	gui.coin = {}
	gui.coin.img = LG.newImage("img/coin.png")
	gui.coin.n = 0
	gui.coin.nt = 0

	gui.help = true

	gui.pay = false

	gui.time = timer.newTime()
end

function gui.update(dt)
	if startoff and player.state == "moving" then
		gui.fuel.n = gui.fuel.n - player.tankfactor*(player.sx + player.sy)*dt/70
	end

	if gui.fuel.n <= 0 then gui.fuel.n = 0 end
	if gui.fuel.n >= 100 then gui.fuel.n = 100 end

	if player.state == "idle" then
		gui.pay = false
	end

	if player.state == "finished" then
		print(gui.pay)
		if not gui.pay then
			if player.pay then
				gui.coin.n = gui.coin.n + math.ceil(0.75 * gui.coin.nt)
				gui.coin.nt = 0
				gui.pay = true
			else
				gui.coin.n = gui.coin.n + gui.coin.nt
				gui.coin.nt = 0
				gui.pay = true
			end
		end
	end
end

function gui.draw()
	if gui.doDraw then
		LG.draw(gui.fuel.img, 610, 5)
		LG.rectangle("fill", 618, 375, 5, -340*gui.fuel.n/100)

		-- LG.draw(gui.eject.img, 580, 5)
		LG.draw(gui.coin.img, 510,10)
		LG.print("x "..gui.coin.n.." + "..gui.coin.nt, 527,7)

		if player.pay then
			LG.print("\n-25%", 557, 7)
		end

		if timer.get(gui.time) <= 3 then
			LG.print("Welcome fellow player! This is your drill, start it with [spacebar].", 40, 310)
		elseif timer.get(gui.time) <= 7 then
			LG.print("Destroy rocks to get money. Better minerals mean better money.", 40, 310)
		elseif timer.get(gui.time) <= 12 then
			LG.print("If you're not mining, you can buy stuff with [b].", 40, 310)
		elseif timer.get(gui.time) <= 17 then
			LG.print("By the way, there's an evil monster down there, which disturbs the shopkeeper.\nMaybe you can help out?", 40, 310)
		elseif timer.get(gui.time) <= 24 then
			LG.print("That's it! Have fun digging!", 40, 310)
		elseif timer.get(gui.time) <= 28 then
			LG.print("Wanna see this message again? Press [h]!", 40, 310)
		end

		if boss.dead then
			LG.print("You've reached the end of the game, congrats!", 100, 350)
		end

		if boss.start then
			LG.print("\"BOSS\"", 10,10)
			LG.rectangle("fill", 60, 17, 40*(#boss.warts), 5)
		end
	end
end

function gui.keypressed(key)
	if key == "h" then
		timer.delete(gui.timer)
		gui.timer = timer.newTime()
	end
end