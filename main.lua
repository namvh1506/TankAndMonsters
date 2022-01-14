local anim8 = require 'anim8'
require "loadImagesandSounds"
require "boss"
require "menu"


function love.load()
	sprite = love.graphics.newImage("assets/spritesheet.png")
	local gs = anim8.newGrid(256,256,sprite:getWidth(),sprite:getHeight(), 0, 0, 0)
	-- frames, d. delay, individual frame delays --
	bomb_anim = anim8.newAnimation(gs("1-18",1),0.3)
	bomberbomb_anim = anim8.newAnimation(gs("1-20",3),0.3)
	gameover_anim = anim8.newAnimation(gs("1-12",5),0.4)
	mine_anim = anim8.newAnimation(gs("1-10",7),0.3)
	bossbomb_anim = anim8.newAnimation(gs("1-5",9),0.1)
	explode_anim = anim8.newAnimation(gs("6-12",5),0.06)
	shoothit_anim = anim8.newAnimation(gs("6-8",5),0.08)
	
	
	local gsboss = anim8.newGrid(520,420,sprite:getWidth(),sprite:getHeight(), 0, 2304, 0)
	bossdie_anim = anim8.newAnimation(gsboss("1-15",1),0.5)
	bossfire_anim = anim8.newAnimation(gsboss("1-14",2),0.1)
	bossattack_anim = anim8.newAnimation(gsboss("1-12",3,"12-1",3),0.1)
	bossmove_anim = anim8.newAnimation(gsboss("1-12",4),0.08)
	bossfun_anim = anim8.newAnimation(gsboss("1-2",1,"2-1",1),0.08)

	secondsCount = 0   -- Use for function count every second --
	mainmenu = true

	
	fullscreenWidth = love.graphics:getWidth()
	fullscreenHeight = love.graphics:getHeight()
	
	
	scoretowin = 50
	scoretowin_half = math.floor(scoretowin/2)
	costumeWidth = 256
	costumeHeight = 256
	itemTimeout = 0

	math.randomseed(os.time())
	k = 0
	ammo_lock = 0 -- lock only 1 ammo/s --
	
	tank = {}
	tank.x = 690
	tank.y = 600
	tank.direction = "up"
	score = 0
	tank.health = 4
	
	
	gun = {}
	gun.x = tank.x
	gun.y = tank.y
	gun.direction = tank.direction
	
	LoadDefault()
	
	bomb = {}
	bomb_quantity = 3
	bomb_fire = false
	
	
	instructions_no = 1		-- Function to check instruction pages --
	in_read_instructions = false
	
	lock_key = 1			-- Function to avoid update every frame --
	lock_monster = 1
	
	mine_explore = false	
	boss_fightonly = false  -- boss_fightonly true when reach score to achieve key --
	boss_key = false		-- boss_key true when player ready and take the key to fight Boss --
	
	-- animate tank chase the Boss in the end -- 
	funvictory = -600     
	funvictory_reverse = true
	
	
	LoadImages()
	LoadSounds()
	
	menu_theme = images.menu_newgame
	img_tank = images.tank_up
	img_gun = images.gun_up
	funvictory_image = images.monster_lucky
	
	-- Creat tank health bar array --
	tankbar = {}
	tankbar.costumes = {}
	tankbar.image = love.graphics.newImage("assets/tankbar.png")
	tankbar_costumes_Width = 57
	tankbar_costumes_Height = 20
	for i = 0, 4 do
		table.insert(tankbar.costumes, love.graphics.newQuad(i * tankbar_costumes_Width, 0, tankbar_costumes_Width,tankbar_costumes_Height, tankbar.image:getDimensions()))
	end

	
	-- Creat item time bar array --
	timebar = {}
	timebar.costumes = {}
	timebar.image = love.graphics.newImage("assets/timebar.png")
	timebar_costumes_Width = 120
	timebar_costumes_Height = 36
	for i = 0, 15 do
		table.insert(timebar.costumes, love.graphics.newQuad(i * timebar_costumes_Width, 0, timebar_costumes_Width, timebar_costumes_Height, timebar.image:getDimensions()))
	end
 
	-- key to fight the boss, make it appear when score 50) --
	key = {}
	key.image = images.key
	key.x = 690
	key.y = 650
	
	-- Load Boss --
	LoadBoss()
 
end

-- Entity Storage

ammos = {}
monsters = {} -- array of monsters
bomberbombs = {}
bulletshooters = {}
items = {}
mines = {}
explosions = {}
shoothits = {}

-- Check the collision --
function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end


function love.update(dt)
	if mainmenu == false then
		-- Start the game if out of menu --
		if victory == false and gameover_anim.position < 12 then
		main_event(dt)
		elseif gameover_anim.position == 12 then
			love.audio.stop(sounds.start, sounds.scorehalf, sounds.boss1, sounds.boss2, sounds.alarm)
			love.audio.play(sounds.lose)
		else
			boss.animation = bossdie_anim
			if bossdie_anim.position < 15 then
				bossdie_anim:update(dt)
			end
			for i = #monsters, 1, -1 do
				local monster = monsters[i]
				mine = {}
				mine.x = monster.x
				mine.y = monster.y
				mine.anim = mine_anim:clone()
				table.insert(mines, mine)
				table.remove(monsters, i)
			end
			
			for i = #mines, 1, -1 do
				local mine = mines[i]
				mine.anim:update(dt)
			end
			
			for i = #bomberbombs, 1, -1 do
				local bomberbomb = bomberbombs[i]
				bomberbomb.anim:update(dt)
			end
			table.remove(shoothits, #shoothits)
			
			for i = #items, 1, -1 do
				local item = items[i]
				table.remove(items, i)
			end
			
			table.remove(shoothits, #shoothits)
			
			love.audio.stop(sounds.boss2, sounds.alarm)
			love.audio.play(sounds.victory)
		end
		
		-- Animation in victory screen --
		if bossdie_anim.position == 15 then
			bossfun_anim:update(dt)
			if funvictory > fullscreenWidth + 50 or funvictory < -600 then
				funvictory_reverse = not funvictory_reverse
				bossfun_anim:flipH()
				local n = math.random(1, 6)
				if n == 1 then
					funvictory_image = images.monster_zombie
				elseif n == 2 then
					funvictory_image = images.monster_shooter
				elseif n == 3 then
					funvictory_image = images.monster_bomber
				elseif n == 4 then
					funvictory_image = images.monster_troller
				elseif n == 5 then
					funvictory_image = images.monster_mine
				else
					funvictory_image = images.monster_lucky 
				end
			end
			if funvictory_reverse == true then
				funvictory = funvictory + 150 * dt
			else
				funvictory = funvictory - 150 * dt
			end
		end
	else 	
		-- Menu theme --
		menu()
	end	
end




function main_event(dt)
	doneIfVictory()
	playSounds()
	-- Every speed relevant with (dt) function, priority put first of "function love.update(dt)"

	-- check ammos direction to shoot --
	checkTankAmmosDirection(dt)
	
	if itemTimeout >= 1 then
		itemTimeout = itemTimeout - 0.7 * dt
	else 
		LoadDefault()
	end
	
	for i = #shoothits, 1, -1 do
		local shoothit = shoothits[i]
		if shoothit.anim.position == 3 then
			table.remove(shoothits, i)
		end
		shoothit.anim:update(dt)
	end
	
	if bomb_fire == true then
		bomb_anim:update(dt)
	end
	
	for i = #bomberbombs, 1, -1 do
		local bomberbomb = bomberbombs[i]
		bomberbomb.anim:update(dt)
	end
	
	
	for i = #mines, 1, -1 do
		local mine = mines[i]
		mine.anim:update(dt)
	end
	
	for i = #explosions, 1, -1 do
		local explosion = explosions[i]
		if explosion.anim.position == 7 then
			table.remove(explosions, i)
		end
		explosion.anim:update(dt)
	end
	
	if isAlive == false and gameover_anim.position < 12 then
		gameover_anim:update(dt)
	end
	
	-- Item has time, if timeup then disappear --
	for i = #items, 1, -1 do
		local item = items[i]
		item.time = item.time - dt
		if item.time <= 0 then
			table.remove(items, i)
		end
	end
	
	secondsCount = secondsCount + dt
	-- Use for function count every second --
	
	if ammo_lock < 1.1 then 
		ammo_lock = ammo_lock + ammo_discharge_rate * dt 
	end
	
	for i = #bulletshooters, 1, -1 do
		local bulletshooter = bulletshooters[i]
		bulletshooter.x = bulletshooter.x + bulletshooter.tanX * bulletshooter.speed * dt;
		bulletshooter.y = bulletshooter.y + bulletshooter.tanY * bulletshooter.speed * dt;
	end

	-- countdown Boss appear -- 
	if boss_key == true and boss_time_appear > 0 then
		boss_time_appear = boss_time_appear - dt
	end
	
	lock_monster = lock_monster + dt
	
	
	-- Control the tank--
	if isAlive == true then
		if love.keyboard.isDown("right") and tank.x < fullscreenWidth - 99 then
		tank.x = tank.x + tank.speed * dt
		tank.direction = "right"
		elseif love.keyboard.isDown("left") and tank.x > 0 then
		tank.x = tank.x - tank.speed * dt
		tank.direction = "left"
		elseif love.keyboard.isDown("up") and tank.y > 0 then
		tank.y = tank.y - tank.speed * dt
		tank.direction = "up"
		elseif love.keyboard.isDown("down") and tank.y < fullscreenHeight - 99 then 
		tank.y = tank.y + tank.speed * dt
		tank.direction = "down"
		end
	end
	
	gun.x = tank.x
	gun.y = tank.y
	gun.direction = tank.direction
	if bomb_quantity > 0 and bomb_fire == false and isAlive == true then
		if love.keyboard.isDown("z") then
			lockdamagebombOnBoss = false    -- resetlock allow bomb damage the Boss when you put a new bomb --
			bomb_anim:pauseAtStart()
			bomb_anim:resume()
			bomb_fire = true
			bomb.x = tank.x
			bomb.y = tank.y - 20
			bomb_quantity = bomb_quantity - 1
			love.audio.play(sounds.reload)
		end
	end
	

	
	-- fire ammo when press space--
	if love.keyboard.isDown("space") and isAlive == true then
		-- fire ammo when press space--
		if ammo_lock >= 1 then
			ammo = {}
			ammo.direction = tank.direction
			ammo.model = gun.model
			if ammo.model == "gun_power" then
				ammo.damage = 3
			else 
				ammo.damage = 1
			end
			
			if ammo.direction == "up" then
				ammo.x = tank.x + 42
				ammo.y = tank.y
			elseif ammo.direction == "down" then
				ammo.x = tank.x + 42
				ammo.y = tank.y + 84
			elseif ammo.direction == "left" then
				ammo.x = tank.x 
				ammo.y = tank.y + 42
			elseif ammo.direction == "right" then
				ammo.x = tank.x + 84
				ammo.y = tank.y + 42
			end
			

		if ammo.direction == "up" then
			ammo.image = images.ammo_up
		elseif ammo.direction == "down" then
			ammo.image = images.ammo_down
		elseif ammo.direction == "left" then
			ammo.image = images.ammo_left
		elseif ammo.direction == "right" then
			ammo.image = images.ammo_right
		end
		
		if ammo.model == "gun_power" then
			if ammo.direction == "up" then
				ammo.image = images.ammobig_up
			elseif ammo.direction == "down" then
				ammo.image = images.ammobig_down
			elseif ammo.direction == "left" then
				ammo.image = images.ammobig_left
			elseif ammo.direction == "right" then
				ammo.image = images.ammobig_right
			end
		end
		
			table.insert(ammos, ammo)
			ammo_lock = ammo_lock - 1
			if ammo.model == "gun_default" then
				love.audio.play(sounds.ammo)
			elseif ammo.model == "gun_power" then
				love.audio.play(sounds.bigammo)
			else
				love.audio.play(sounds.nonreloadammo)
			end
		end
	end
	
	-- Animate the gun on the tank when fire-- 
	if ammo_lock < 0.2 then
		if tank.direction == "up" then
			gun.y = gun.y + 10
		elseif tank.direction == "down" then
			gun.y = gun.y - 10
		elseif tank.direction =="left" then
			gun.x = gun.x + 10
		elseif tank.direction == "right" then
			gun.x = gun.x - 10
		end
	end
	
	
	 -- check ammos direction to shoot 2nd time for lag, cause ammospeed slower than expected --
	checkTankAmmosDirection(dt)
	
-- Add new monster on every amount of time (First monster appear on 2nd sec + lock 1 monster per 2s + randomly monster)--
	if boss_fightonly == false then 
		if lock_monster >= 2 then 
		lock_monster = lock_monster - 2
		recallMonster()
		end
		if math.random(1,4500) == 1 then
		recallMonster()
		end
	end	
	
	
	-- Check collision of monster with ammo and check if it survive (put on priority, avoid bug) --
	for i = #monsters, 1, -1 do
		local monster = monsters[i]
		for i = #ammos, 1, -1 do
			local ammo = ammos[i]
			if CheckCollision(ammo.x, ammo.y, 16*1.2, 16*1.2, monster.x, monster.y,img_monster:getWidth()*0.4, img_monster:getHeight()*0.35) then
				monster.health = monster.health - ammo.damage
				shoothit = {}
				if ammo.direction == "up" then
					shoothit.x = ammo.x - 15
					shoothit.y = ammo.y - 40
				elseif ammo.direction == "down" then   	-- for some reason animation look not good, ammo not touch the monster on collision
					shoothit.x = ammo.x	- 15				-- then I add some features to fix that
					shoothit.y = ammo.y + 5
				elseif ammo.direction == "left" then
					shoothit.x = ammo.x	- 30	
					shoothit.y = ammo.y - 15
				else
					shoothit.x = ammo.x	+ 5
					shoothit.y = ammo.y - 15
				end
				shoothit.anim = shoothit_anim:clone()
				table.insert(shoothits, shoothit)
				table.remove(ammos, i)
			end
		end
	end
	
	-- Function how monsters move --
	for i = #monsters, 1, -1 do
		local monster = monsters[i]
		if monster.model == "zombie" then
			if monster.x < tank.x then 									-- If the zombie is to the left of the tank:
				monster.x = monster.x + (monster.speed * 2.5 * dt)		-- zombie moves towards the right.
			end
			 
			if monster.x > tank.x then 									-- If the zombie is to the right of the tank:
				monster.x = monster.x - (monster.speed * 2.5 * dt) 		-- zombie moves towards the left.
			end
			 
			if monster.y < tank.y then 									-- If the zombie is above the tank:
				monster.y = monster.y + (monster.speed * 2.5 * dt)		-- zombie moves downward.
			end
			 
			if monster.y > tank.y then 									-- If the zombie is below the tank:
				monster.y = monster.y - (monster.speed * 2.5 * dt)		-- zombie moves upward.
			end
		
		elseif monster.model == "shooter" or monster.model == "bomber" then			-- Shooter and Bomber move less zigzag and maybe stop in second--
			if monster.x < monster.destination_x then 
				monster.x = monster.x + (monster.speed * 2.5 * dt)
			end
			 
			if monster.x > monster.destination_x then 
				monster.x = monster.x - (monster.speed * 2.5 * dt)
			end
			 
			if monster.y < monster.destination_y then 	
				monster.y = monster.y + (monster.speed * 2.5 * dt)
			end
			 
			if monster.y > monster.destination_y then 					
				monster.y = monster.y - (monster.speed * 2.5 * dt)		
			end
			if math.random(0,5000) == 1 then
				monster.destination_x = math.random(0, fullscreenWidth - 99)
				monster.destination_y = math.random(0, fullscreenHeight - 99)
			end
			
		elseif monster.model == "troller" or monster.model == "lucky" then			-- Troller and lucky move more zigzag --
			if monster.x < monster.destination_x then 
				monster.x = monster.x + (monster.speed * 2.5 * dt)
			end

			if monster.x > monster.destination_x then 
				monster.x = monster.x - (monster.speed * 2.5 * dt)
			end
			 
			if monster.y < monster.destination_y then 	
				monster.y = monster.y + (monster.speed * 2.5 * dt)
			end
			 
			if monster.y > monster.destination_y then 					
				monster.y = monster.y - (monster.speed * 2.5 * dt)		
			end
			if math.random(0, 1000) == 1 then
				monster.destination_x = math.random(0, fullscreenWidth - 99)
				monster.destination_y = math.random(0, fullscreenHeight - 99)	
			end
		end	
	end
		

	
	-- Animate bomb --
	
	if bomb_anim.position > 14 and (bomb_fire == true) and CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, bomb.x, bomb.y, costumeWidth*0.4, costumeHeight*0.4) then
		checkIfTankgetHit()
	end
	
	if bomb_anim.position == 18 then
		bomb_anim:pauseAtStart()
		bomb_fire = false
	end
	
	-- Check collision of monster with tank and check if it survive --
	for i = #monsters, 1, -1 do
			
		local monster = monsters[i]
		if CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, monster.x, monster.y,img_monster:getWidth()*0.34, img_monster:getHeight()*0.34) then
			checkIfTankgetHit()					-- checkIfgetHit function above --
			if tank.model == "tank_shield" then
				monster.health = 0
			end
		end
		if bomb_anim.position > 16 and (bomb_fire == true) and CheckCollision(monster.x, monster.y, img_monster:getWidth()*0.4, img_monster:getHeight()*0.4, bomb.x - 70, bomb.y - 70, costumeWidth * 0.8, costumeHeight * 0.8) then
			monster.health = 0
		end

		-- Monster death when health on zero, monster "lucky" reduce time every frame, loop reverse to avoid error when delete the monster --
		if monster.model == "lucky" then
			monster.time = monster.time - dt
		end
		if monster.health <= 0 then
			score = score + 1
			explosion = {}
			explosion.x = monster.x
			explosion.y = monster.y
			explosion.anim = explode_anim:clone()
			table.insert(explosions, explosion)
			table.remove(monsters, i)
			love.audio.play(sounds.monsterexplode)
		end
		
		if monster.model == "lucky" then
			if monster.time <= 0 then
				getRandomItem(monster.x + 36, monster.y + 36)
				table.remove(monsters, i)
			end
		end
		
		
		
	end
	
	-- MONSTERS MONSTERS MONSTERS --
	-- MONSTERS MONSTERS MONSTERS --
	-- MONSTERS MONSTERS MONSTERS --
	
		-- Bombs of the monster "bomber" --
	for i = #monsters, 1, -1 do 
		local monster = monsters[i]
		k = i
		if (monster.model == "bomber" and math.random(1, 1200) == 1) then
			bomberbomb = {}
			if math.random(1,10) > 5 then
				x = 1
			else
				x = -1
			end
			bomberbomb.x = tank.x + math.random(120, 250) * x
			if math.random(1,10) > 5 then
				y = 1
			else
				y = -1
			end
			bomberbomb.y = tank.y + math.random(120, 250) * y
			bomberbomb.anim = bomberbomb_anim:clone()

			table.insert(bomberbombs, bomberbomb)   -- Add new bomb randomly -- 
		end
	
		
		-- Bullet of the monster "shooter"--
		if (monster.model == "shooter" and math.random(1, 800) == 1) then
			bulletshooter = {}
			bulletshooter.x = monster.x
			bulletshooter.y = monster.y
			bulletshooter.old_x = bulletshooter.x 
			bulletshooter.old_y = bulletshooter.y

			local k = math.random(1, 4)
			if k == 1 then
				bulletshooter.destination_x = math.random(10, 60) * (-1)
				bulletshooter.destination_y = math.random(0, fullscreenHeight)
			elseif k == 2 then
				bulletshooter.destination_x = math.random(fullscreenWidth, fullscreenWidth + 50)
				bulletshooter.destination_y = math.random(0, fullscreenHeight)
			elseif k == 3 then
				bulletshooter.destination_x = math.random(0, fullscreenWidth)
				bulletshooter.destination_y = math.random(fullscreenHeight, fullscreenHeight + 50)
			else
				bulletshooter.destination_x = math.random(0, fullscreenWidth)
				bulletshooter.destination_y = math.random(10, 60) * (-1)
			end
			bulletshooter.image = love.graphics.newImage("assets/bulletshooter.png")
			bulletshooter.speed = 100
			dX = bulletshooter.destination_x - bulletshooter.old_x;
			dY = bulletshooter.destination_y - bulletshooter.old_y;

			bulletshooter.distance = math.sqrt(dX^2 + dY^2);
			bulletshooter.tanX = dX / bulletshooter.distance;
			bulletshooter.tanY = dY / bulletshooter.distance;
			table.insert(bulletshooters, bulletshooter)
		end
		
		-- Check bulletshooter interract with monster mine --
		for i = #bulletshooters, 1, -1 do
			local bulletshooter = bulletshooters[i]		
			if monster.model == "mine" and CheckCollision(monster.x + 15, monster.y + 15, img_monster:getWidth()*0.3, img_monster:getHeight()*0.3, bulletshooter.x, bulletshooter.y, bulletshooter.image:getWidth()*0.4, bulletshooter.image:getHeight()*0.4) then
				mine_explore = true
				table.remove(bulletshooters, i)
				local monster = monsters[k]
				table.remove(monsters, k)
			end	
		end
		
		-- Check bomb interract with monster mine --
		for i = #bomberbombs, 1, -1 do
			local bomberbomb = bomberbombs[i]
			if monster.model == "mine" and bomberbomb.anim.position > 15 and CheckCollision(monster.x, monster.y, img_monster:getWidth()*0.4, img_monster:getHeight()*0.4, bomberbomb.x, bomberbomb.y, costumeWidth*0.4, costumeHeight*0.4) then
				mine_explore = true
				local monster = monsters[k]
				table.remove(monsters, k)
			end
		end
		
		-- Add mine to array mines, "mine_explore = false" lock mean mine monster explode only one time --
		if mine_explore == true then 
			mine1 = {}
			mine1.x = monster.x
			mine1.y = monster.y
			mine1.anim = mine_anim:clone()
			table.insert(mines, mine1)
			
			mine2 = {}
			mine2.x = monster.x - 80
			mine2.y = monster.y - 80
			mine2.anim = mine_anim:clone()
			table.insert(mines, mine2)
			
			mine3 = {}
			mine3.x = monster.x - 80
			mine3.y = monster.y + 80
			mine3.anim = mine_anim:clone()
			table.insert(mines, mine3)
			
			mine4 = {}
			mine4.x = monster.x + 80
			mine4.y = monster.y - 80
			mine4.anim = mine_anim:clone()
			table.insert(mines, mine4)
			
			mine5 = {}
			mine5.x = monster.x + 80
			mine5.y = monster.y + 80
			mine5.anim = mine_anim:clone()
			table.insert(mines, mine5)
			mine_explore = false	
		end	
		
		
		-- Troller will follow tank with high speed if tank stand equal to it horizontally --
		if monster.model == "troller" and (monster.y - tank.y) < 70 and (monster.y - tank.y) > -50 then
			if monster.x < tank.x then
				monster.x = monster.x + 40 * 2.5 * dt
			else 
				monster.x = monster.x - 40 * 2.5 * dt
			end
		end
		
	end
	
	
	-- Check bomb for the collision with tank, remove when it done with explode--
	for i = #bomberbombs, 1, -1 do
		local bomberbomb = bomberbombs[i]
		
		if bomberbomb.anim.position > 15 and CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, bomberbomb.x, bomberbomb.y, costumeWidth*0.62, costumeHeight*0.62) then
			checkIfTankgetHit()
		end
		
		if bomberbomb.anim.position == 20 then
			bomberbomb.anim:pause()
			table.remove(bomberbombs, i)
		end
	end
	
	-- Check bulletshooter for the collision with tank and remove after outside screen --
	for i = #bulletshooters, 1, -1 do
		local bulletshooter = bulletshooters[i]
		if CheckCollision(tank.x + 15, tank.y + 15, images.tank_up:getWidth()*0.2, images.tank_up:getHeight()*0.2, bulletshooter.x, bulletshooter.y, bulletshooter.image:getWidth()*0.4, bulletshooter.image:getHeight()*0.4) then
			checkIfTankgetHit()
			table.remove(bulletshooters, i)
		end
		
		if (math.sqrt((bulletshooter.x-bulletshooter.old_x)^2 + (bulletshooter.y-bulletshooter.old_y)^2) >= bulletshooter.distance) then
			table.remove(bulletshooters, i)
		end		
	end
	
	
	-- Explode the mine -- 	
	for i = #mines, 1, -1 do
		local mine = mines[i]
			
		if mine.anim.position > 3 and CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, mine.x, mine.y, costumeWidth*0.5, costumeHeight*0.5) then
			checkIfTankgetHit()
		end
			
		if mine.anim.position == 10 then
			mine.anim:pause()
			table.remove(mines, i)
		end
	end
	

	
	-- Check tankstatus, set <= 0 avoid bug (tested for somehow tank take damage and health become -1 the game will continue if set == 0)-- 
	if tank.health <= 0 then
		isAlive = false
		love.audio.play(sounds.bomb)
	end
	
	-- Get item on map randomly, if boss fight item more high chance appear on the map --
	if boss_key == false then
		if #items < 2 and math.random(1, 3500) == 1 then
			getRandomItem(math.random(0, fullscreenWidth - 60), math.random(0, fullscreenHeight - 60))		
		end
	else
		if #items < 2 and math.random(1, 3000) == 1 then
			getRandomItem(math.random(0, fullscreenWidth - 60), math.random(0, fullscreenHeight - 60))		
		end
	end
	
	checkTank()
	checkIfItem()		-- check effect if tank take the item --
	checkIfBossFight()	-- check if tank reach fixed score to fight the boss --
	checkIfBossKey()    -- check if tank ready take the key to fight the boss --
	
	-- Update Boss animation per frame --
	if boss_key == true and boss_time_appear <= 0 then
		BossUpDate(dt)
	end

end



function love.draw()
	-- Draw the menu --
	if mainmenu == true then
			love.graphics.draw(menu_theme, 0, 0)
		return
	end
	
	-- draw background --
	love.graphics.draw(images.background)
	
	
	-- Draw if the key is found when reach score --
	if boss_fightonly == true and boss_key == false then
		love.graphics.draw(key.image, key.x - 50, key.y, 0, 0.5, 0.5)
	end
	

	-- draw bossbombs on main.lua for undertank purpose --
	for i = #bossbombs, 1, -1 do
	local bossbomb = bossbombs[i]
		bossbomb.anim:draw(sprite, bossbomb.x, bossbomb.y, 0, 0.6, 0.6)
	end

	-- draw the bomberbomb --
	for i = #bomberbombs, 1, -1 do
		local bomberbomb = bomberbombs[i]
		if bomberbomb.anim.position < 15 then
			bomberbomb.anim:draw(sprite, bomberbomb.x + 25.6, bomberbomb.y + 25.6, 0, 0.5, 0.5)
		else
			bomberbomb.anim:draw(sprite, bomberbomb.x, bomberbomb.y, 0, 0.7, 0.7)
		end
	end
	
	-- draw the bulletshooters --
	for i = #bulletshooters, 1, -1 do
		local bulletshooter = bulletshooters[i]
		love.graphics.draw(bulletshooter.image, bulletshooter.x, bulletshooter.y, 0, 0.6, 0.6)
	end
		
	-- draw the bomb --
	if bomb_fire == true then
		bomb_anim:draw(sprite, bomb.x, bomb.y, 0, 0.5, 0.5)
		if bomb_anim.position == 17 then
			love.graphics.draw(images.explode, bomb.x - 70, bomb.y - 70, 0, 0.8, 0.8)
		end
	end


	
	--draw the monsters--
	for i = 1, #monsters, 1 do
		local monster = monsters[i]
		love.graphics.draw(monster.image, monster.x, monster.y, 0, 0.4, 0.4)
	end
	
	-- draw the items --
	for i = #items, 1, -1 do
		local item = items[i]
		love.graphics.draw(item.image, item.x, item.y, 0, 0.4, 0.4)
	end
	

	-- draw the mine explode --
	for i = #mines, 1, -1 do
		local mine = mines[i]
		mine.anim:draw(sprite, mine.x, mine.y, 0, 0.6, 0.6)
	end
	
	
	-- draw the tank and gun --	
	drawTank()
	
	-- draw ammos
	for i = #ammos, 1, -1 do
		local ammo = ammos[i]
		love.graphics.draw(ammo.image, ammo.x, ammo.y, 0, 1.2, 1.2)
	end

	
	
	
	love.graphics.print("SCORE: "..score, 1290, 10)
	love.graphics.print("BOMB: "..bomb_quantity, 80, 10)
	

	
	drawTimeBar() 		-- Draw time countdown bar when use item -- 
	
	-- Draw tank health bar --
	if tank.health >= 0 then
		love.graphics.draw(tankbar.image, tankbar.costumes[tank.health + 1], 11, 7)
	end
	
	-- Draw warning sign if low health, or boss on rage -- 
	if tank.health == 1 or boss.rage >= 262 then
		if math.floor(2 * secondsCount) % 2 == 0 then 
			love.graphics.draw(images.warningoff, 11, 32)
		else
			love.graphics.draw(images.warningon, 11, 32)
		end
		love.audio.play(sounds.alarm)
	end
	
	
	-- Draw bosswarning --
	if boss_key == true and boss_time_appear > 0 then
		love.graphics.draw(images.noenter,  540, 20, 0, 0.5, 0.5)
		if math.floor(2 * secondsCount) % 2 == 0 then 
			love.graphics.draw(images.bosswarning1, (fullscreenWidth - 0.7*images.bosswarning1:getWidth()) / 2, (fullscreenHeight - 0.7*images.bosswarning1:getHeight()) / 2, 0, 0.7, 0.7)
		else
			love.graphics.draw(images.bosswarning2, (fullscreenWidth - 0.7*images.bosswarning2:getWidth()) / 2, (fullscreenHeight - 0.7*images.bosswarning2:getHeight()) / 2, 0, 0.7, 0.7)
		end
		love.audio.play(sounds.bossalarm)
	end
	
	-- Draw Boss --
	if boss_key == true then
		BossDraw()
	end
	
		
	-- draw shoothit explosion --
	for i = #shoothits, 1, -1 do
		local shoothit = shoothits[i]
		shoothit.anim:draw(sprite, shoothit.x, shoothit.y, 0, 0.2, 0.2)
	end
	
	-- draw explosions --
	for i = #explosions, 1, -1 do
		local explosion = explosions[i]
		explosion.anim:draw(sprite, explosion.x - 20, explosion.y - 20, 0, 0.5, 0.5)
	end
	
	if warning_bossfight2 > 0 then
		love.graphics.draw(images.boss2, 0, 0)
	end
	
	-- Draw if gameover, press space to restart, esc to quit --
	if gameover_anim.position == 12 then
		love.graphics.draw(images.over_screen, 0, 0, 0, 1, 1)
		if love.keyboard.isDown("space") then
			love.event.quit("restart")
		end
	end
	
	-- Draw if victory --
	if bossdie_anim.position == 15 then
		love.graphics.draw(images.victory, 0, 0, 0, 1, 1)
		if funvictory_reverse == true then
			love.graphics.draw(images.tank_right, funvictory, 90, 0, 0.4, 0.4)
			love.graphics.draw(images.gun_right, funvictory, 90, 0, 0.4, 0.4)
			love.graphics.draw(funvictory_image, funvictory + 300, 155, 0, 0.2, 0.2)
		else
			love.graphics.draw(images.tank_left, funvictory + 420, 90, 0, 0.4, 0.4)
			love.graphics.draw(images.gun_left, funvictory + 420, 90, 0, 0.4, 0.4)
			love.graphics.draw(funvictory_image, funvictory + 170, 155, 0, 0.2, 0.2)
		end
		bossfun_anim:draw(sprite, funvictory + 100, 20, 0, 0.6, 0.6)
	end

end



function love.keyreleased(key) -- Quick quit game --
   if key == "escape" then
		love.event.quit()
   end
end


function recallMonster()

	monster = {}
	
	monster.time = math.random(5, 15)
	monster.destination_x = math.random(0, fullscreenWidth - 99)
	monster.destination_y = math.random(0, fullscreenHeight - 99)    -- Default destination move of monsters --
	
	
	monster.position = math.random(1,4)
	if monster.position == 1 then
		monster.x = 0
		monster.y = 0
	elseif monster.position == 2 then
		monster.x = fullscreenWidth
		monster.y = 0
	elseif monster.position == 3 then
		monster.x = 0
		monster.y = fullscreenHeight
	elseif monster.position == 4 then
		monster.x = fullscreenWidth
		monster.y = fullscreenHeight
	end
	
	-- Zombie: 20%, Shooter: 20%, Bomber: 20%, Troll: 10%, Mine: 20%, Lucky: 10% --
	monster.modelnum = math.random(1, 10000)
	if monster.modelnum <= 2000 then
		monster.model = "zombie"
		monster.health = 4
		monster.speed = math.random(15,50)
		img_monster = images.monster_zombie
	elseif monster.modelnum <= 4000 then
		monster.model = "shooter"
		monster.health = 2
		monster.speed =  30
		img_monster = images.monster_shooter
	elseif monster.modelnum <= 6000 then
		monster.model = "bomber"
		monster.health = 2
		monster.speed = 20
		img_monster = images.monster_bomber
	elseif monster.modelnum <= 7000 then
		monster.model = "troller"
		monster.health = 5
		monster.speed = math.random(5,20)
		img_monster = images.monster_troller
	elseif monster.modelnum <= 9000 then
		monster.model = "mine"
		monster.health = 3
		monster.speed = 0
		img_monster = images.monster_mine
		if math.random(1,10) > 5 then
			x = 1
		else
			x = -1
		end
		monster.x = tank.x + math.random(150, 250) * x
		if monster.x < 0 or monster.x > (fullscreenWidth - 200) then 
			monster.x = (-1)* monster.x
		end
		
		if math.random(1,10) > 5 then
			y = 1
		else
			y = -1
		end
		monster.y = tank.y + math.random(150, 250) * y
		if monster.y < 0 or monster.y > (fullscreenHeight - 200) then 
			monster.y = (-1)* monster.y
		end
	else
		monster.model = "lucky"
		monster.health = 1
		monster.speed = math.random(40,80)
		img_monster = images.monster_lucky
		if math.random(1,10) > 5 then
			x = 1
		else
			x = -1
		end
		monster.x = tank.x + 500 * x
		if math.random(1,10) > 5 then
			y = 1
		else
			y = -1
		end
		monster.y = tank.y + 500 * y
	end
	
	if monster.model == "zombie" then
		monster.image = images.monster_zombie
	elseif monster.model == "shooter" then
		monster.image = images.monster_shooter
	elseif monster.model == "bomber" then
		monster.image = images.monster_bomber
	elseif monster.model == "troller" then
		monster.image = images.monster_troller
	elseif monster.model == "mine" then
		monster.image = images.monster_mine
	else
		monster.image = images.monster_lucky
	end
	
	table.insert(monsters, monster)

end	


-- Get random item --
function getRandomItem(x,y)

	item = {}
	item.x = x
	item.y = y
	item.time = math.random(7,10)
	item.no = math.random(1, 7)
	
	if item.no == 1 then 
		item.image = images.item_1
	elseif item.no == 2 then 
		item.image = images.item_2
	elseif item.no == 3 then 
		item.image = images.item_3
	elseif item.no == 4 then 
		item.image = images.item_4
	elseif item.no == 5 then 
		if bossfight2 == false then
			item.image = images.item_5  -- item 5 prohibited if boss have health less than half --
		else
			getRandomItem(x,y)
		end
	elseif item.no == 6 then
		item.image = images.item_6
	else
		if boss_key == true then
			item.image = images.item_7  -- item 7 only use for fighting Boss -- 
		else 
			getRandomItem(x,y)
		end
	end
	table.insert(items, item)
	
end

-- Affair when tank take item --
function checkIfItem()
	for i = #items, 1, -1 do
		local item = items[i]
		if CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, item.x - 15, item.y - 15,item.image:getWidth()*0.5, item.image:getHeight()*0.5) then
			if item.no == 1 then  		-- If on items, increasing before timebar reach level max --
				for i = 1, 10, 1 do
					if itemTimeout < 15.5 and itemTimeout > 1 then
						itemTimeout = itemTimeout + 0.5 
					end
				end
				if bomb_quantity < 3 then
					bomb_quantity = bomb_quantity + 1
				end
			elseif item.no == 2 then 
				LoadDefault()
				gun.model = "gun_power"
				ammo_speed = ammo_speed * 0.8
				ammo_discharge_rate = ammo_discharge_rate * 0.5
				itemTimeout = 16
			elseif item.no == 3 then 	-- If on items, increasing before timebar reach level max --
				for i = 1, 10, 1 do
					if itemTimeout < 15.5 and itemTimeout > 1 then
						itemTimeout = itemTimeout + 0.5
					end
				end
				if tank.health < 4 then
					tank.health = tank.health + 1
				end
			elseif item.no == 4 then 
				LoadDefault()
				gun.model = "gun_nonreload"
				ammo_speed = ammo_speed * 2
				ammo_discharge_rate = ammo_discharge_rate * 1.5
				itemTimeout = 16
			elseif item.no == 5 then 
				LoadDefault()
				tank.model = "tank_shield"
				itemTimeout = 16
			elseif item.no == 6 then		-- If on items, increasing before timebar reach level max --
				tank.speed = tank.speed * 1.4
				ammo_speed = ammo_speed * 1.4
				for i = 1, 10, 1 do
					if itemTimeout < 15.5 and itemTimeout > 1 then
						itemTimeout = itemTimeout + 0.5
					else
						itemTimeout = 16
					end
				end
			elseif item.no == 7 then
			LoadDefaultBoss()
			end
			love.audio.play(sounds.item)
			table.remove(items, i)
		end
	end
end

-- Default tank status --
function LoadDefault()
	gun.model = "gun_default"
	tank.model = "tank_default"
	tank.speed = 250
	isAlive = true
	itemTimeout = 0
	ammo_speed = 400
	ammo_discharge_rate = 2
end

-- draw time countdown bar when items in use--
function drawTimeBar()
	for i = 15, 1, - 1 do
		if itemTimeout > i and itemTimeout <= (i + 1) then
			love.graphics.draw(timebar.image, timebar.costumes[i + 1], 138, -1)
		end
	end
end


function checkTank()
	
	if tank.model == "tank_default" then
		if tank.direction == "up" then
			img_tank = images.tank_up
			img_gun = images.gun_up
		elseif tank.direction == "down" then
			img_tank = images.tank_down
			img_gun = images.gun_down
		elseif tank.direction == "left" then
			img_tank = images.tank_left
			img_gun = images.gun_left
		elseif tank.direction == "right" then
			img_tank = images.tank_right
			img_gun = images.gun_right
		end
	elseif tank.model == "tank_shield"	then		-- Check if tank on item --
		if tank.direction == "up" then
			img_tank = images.tankshield_up
			img_gun = images.gunshield_up
		elseif tank.direction == "down" then
			img_tank = images.tankshield_down
			img_gun = images.gunshield_down
		elseif tank.direction == "left" then
			img_tank = images.tankshield_left
			img_gun = images.gunshield_left
		elseif tank.direction == "right" then
			img_tank = images.tankshield_right
			img_gun = images.gunshield_right
		end
	end
	if tank.model == "tank_help" then							-- else tank.model == "tank_help" tank after take damage --
		if tank.direction == "up" then
			img_tank = images.tankhelp_up
			img_gun = images.gunhelp_up
		elseif tank.direction == "down" then
			img_tank = images.tankhelp_down
			img_gun = images.gunhelp_down
		elseif tank.direction == "left" then
			img_tank = images.tankhelp_left
			img_gun = images.gunhelp_left
		elseif tank.direction == "right" then
			img_tank = images.tankhelp_right
			img_gun = images.gunhelp_right
		end
	end
	
	
	-- Check gun model --
	
	if gun.model == "gun_power" then
		if tank.direction == "up" then
			img_gun = images.gunpower_up
		elseif tank.direction == "down" then
			img_gun = images.gunpower_down
		elseif tank.direction == "left" then
			img_gun = images.gunpower_left
		elseif tank.direction == "right" then
			img_gun = images.gunpower_right
		end
	end
	
	if gun.model == "gun_nonreload" then
		if tank.direction == "up" then
			img_gun = images.gunnonreload_up
		elseif tank.direction == "down" then
			img_gun = images.gunnonreload_down
		elseif tank.direction == "left" then
			img_gun = images.gunnonreload_left
		elseif tank.direction == "right" then
			img_gun = images.gunnonreload_right
		end
	end
end
	
		
function drawTank()	
	if isAlive == true then
		love.graphics.draw(img_tank, tank.x, tank.y, 0, 0.4, 0.4)
		love.graphics.draw(img_gun, gun.x, gun.y, 0, 0.4, 0.4)
	else
		gameover_anim:draw(sprite, tank.x, tank.y, 0, 0.4, 0.4)
		if gameover_anim.position == 12 then
			gameover_anim:pauseAtEnd()
		end
	end
end


function checkIfTankgetHit()
	if tank.model == "tank_default" then
		tank.health = tank.health - 1
		LoadDefault()
		LoadDefaultBoss()
		itemTimeout = itemTimeout + 5
		tank.model = "tank_help"
		love.audio.play(sounds.takedamage)
	end
end

function checkIfBossFight()
	if score >= scoretowin and boss_fightonly == false then
		for i = #monsters, 1, -1 do
		local monster = monsters[i]
				mine = {}
				mine.x = monster.x
				mine.y = monster.y
				mine.anim = mine_anim:clone()
				table.insert(mines, mine)
				table.remove(monsters, i)
		end
		boss_fightonly = true
	end
end

function checkIfBossKey()
	if boss_fightonly == true then
		if CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, key.x - 70, key.y ,key.image:getWidth()*0.4, key.image:getHeight()*0.4) then
			boss_key = true
		end
	end
end


function checkTankAmmosDirection(dt)
	for i = #ammos, 1, -1 do
	local ammo = ammos[i]
		if ammo.direction == "up" and ammo.y > -20 then
			ammo.y = ammo.y - ammo_speed * dt
		elseif ammo.direction == "down" and ammo.y < fullscreenHeight + 20 then
			ammo.y = ammo.y + ammo_speed * dt
		elseif ammo.direction == "left" and ammo.x > -20 then
			ammo.x = ammo.x - ammo_speed * dt
		elseif ammo.direction == "right" and ammo.x < fullscreenWidth + 20 then
			ammo.x = ammo.x + ammo_speed * dt
		else
			table.remove(ammos, i) -- remove ammo after outside the range of screen to free memory --
		end
	end
end

function doneIfVictory()
	if victory == true then
	love.audio.stop(sounds)
	end
end


