-- Load Boss --

function LoadBoss()
	boss_time_appear = 3.8
	lockdamagebombOnBoss = true
	warning_bossfight2 = 0
	boss = {}
	boss.health = 320
	boss.rage = 0
	boss.x = 527
	boss.y = 80
	boss.random = 680
	boss.fire = false
	bossfight2 = false
	victory = false
	lockDamageBomb = false
	
	
	if boss.x > tank.x - 100 then					-- Use to function boss animation facing right or left side --
		boss.facetorightside = false
		bossfire_anim:flipH()
		bossmove_anim:flipH()
		bossattack_anim:flipH()
	else
		boss.facetorightside = true
	end
	boss.speed = 31
	images.bosshealthbar = love.graphics.newImage("assets/boss/bosshealthbar.png")
	
	
end

bulletbosses = {}
bossbombs = {}

function BossUpDate(dt)
	
	for i = #bossbombs, 1, -1 do
		local bossbomb = bossbombs[i]
		bossbomb.anim:update(dt)
	end
	
	if boss.animation == bossmove_anim then 
		bossmove_anim:update(dt)
		bossattack_anim.position = 1
		bossfire_anim.position = 1
	elseif boss.animation == bossattack_anim then 
		bossattack_anim:update(dt)
	elseif boss.animation == bossfire_anim then 
		bossfire_anim:update(dt)
		bossattack_anim.position = 1
	end
	
		
	for i = #bulletbosses, 1, -1 do
	local bulletboss = bulletbosses[i]
		bulletboss.x = bulletboss.x + bulletboss.tanX * bulletboss.speed * dt;
		bulletboss.y = bulletboss.y + bulletboss.tanY * bulletboss.speed * dt;
	end
	
	
	if warning_bossfight2 > 0 then
		warning_bossfight2 = warning_bossfight2 - dt
	end
	
	
	-- Boss move like zombie --
	if boss.health > 0 then
		if boss.x < tank.x - 100 then 									
			boss.x = boss.x + (boss.speed * 2 * dt)		 
		elseif boss.x > tank.x - 100 then 									
			boss.x = boss.x - (boss.speed * 2 * dt) 		
		end		 
		if boss.y < tank.y - 80 then 									
			boss.y = boss.y + (boss.speed * 2 * dt)		
		elseif boss.y > tank.y - 80 then 									
			boss.y = boss.y - (boss.speed * 2 * dt)
		end
	end	
	
	
	-- Boss shoot like shooter --
	if math.random(1, math.floor(boss.random)) == 1 and boss.health > 0 then
		boss.fire = true
		bossfire_anim:resume()
		bulletboss = {}
		bulletboss.x = boss.x
		bulletboss.y = boss.y
		bulletboss.old_x = bulletboss.x 
		bulletboss.old_y = bulletboss.y
		if boss.x > tank.x - 100 then
				bulletboss.destination_x = math.random(120, 240) * (-1)
				bulletboss.destination_y = math.random(-50, fullscreenHeight + 50)
		else 
				bulletboss.destination_x = math.random(fullscreenWidth, fullscreenWidth + 50)
				bulletboss.destination_y = math.random(-50, fullscreenHeight + 50)
		end
		if boss.x > tank.x - 110 and boss.x < tank.x + 90 then  
			if boss.y > tank.y then 
				bulletboss.destination_x = math.random(tank.x - 110, tank.x + 110) --if tank near boss, boss randomly shoot in vertical toward to tank
				bulletboss.destination_y = -200									 --avoid it by face the Boss horizontally but Boss will raise Rage bar!
			else
				bulletboss.destination_x = math.random(tank.x - 110, tank.x + 110)
				bulletboss.destination_y = fullscreenHeight + 30
			end
		end
		
		bulletboss.image = love.graphics.newImage("assets/boss/bulletboss.png")
		bulletboss.speed = 200
		dXBoss = bulletboss.destination_x - bulletboss.old_x;
		dYBoss = bulletboss.destination_y - bulletboss.old_y;

		bulletboss.distance = math.sqrt(dXBoss^2 + dYBoss^2);
		bulletboss.tanX = dXBoss / bulletboss.distance;
		bulletboss.tanY = dYBoss / bulletboss.distance;
		table.insert(bulletbosses, bulletboss)
	end
	
	-- Check collision of bulletbosses --
	for i = #bulletbosses, 1, -1 do
		local bulletboss = bulletbosses[i]
		if CheckCollision(tank.x + 15, tank.y + 15, images.tank_up:getWidth()*0.2, images.tank_up:getHeight()*0.2, bulletboss.x + 135, bulletboss.y + 110, bulletboss.image:getWidth()*0.6, bulletboss.image:getHeight()*0.6) then
			checkIfTankgetHit()
			table.remove(bulletbosses, i)
		end

		if (math.sqrt((bulletboss.x - bulletboss.old_x)^2 + (bulletboss.y-bulletboss.old_y)^2) >= bulletboss.distance) then
			table.remove(bulletbosses, i)
		end	
	end
	
	-- Boss put bomb like bomber --
	if math.random(1, math.floor(boss.random)) == 1 and boss.health > 0 then
		bossbomb = {}
		bossbomb.x = math.random(tank.x - 200, tank.x + 200)
		bossbomb.y = math.random(tank.y - 200, tank.y + 200)
		bossbomb.anim = bossbomb_anim:clone()
		bossbomb.anim:pause()
		table.insert(bossbombs, bossbomb)
	end
	
	-- if tank near bossbomb, bossbomb become mine and explode, bombBoss explode when total bombs equal 10 to 20 randomly --
	for i = #bossbombs, 1, -1 do
			local bossbomb = bossbombs[i]

			if CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, bossbomb.x + 20, bossbomb.y + 20, costumeWidth*0.4, costumeHeight*0.4) or #bossbombs == math.random(10,20) or #bossbombs > 25 then
				bossbomb.anim:resume()	
				love.audio.play(sounds.tire)
			end
			
			if bossbomb.anim.position == 5 then
				bossbomb.anim:pause()
				mine = {}
				mine.x = bossbomb.x + 12.8
				mine.y = bossbomb.y + 12.8
				mine.anim = mine_anim:clone()
				table.insert(mines, mine)
				table.remove(bossbombs, i)
			end
	end

	
	-- Handle the animation with Boss -- -- defauft boss animation --
	boss.animation = bossmove_anim
	
	if boss.fire == true then 
		boss.animation = bossfire_anim
		if bossfire_anim.position == 14 then
			bossfire_anim:pauseAtStart()
			boss.fire = false
		end
	end
	
	if ((boss.y - (tank.y - 80)) < 80 and (boss.y - (tank.y - 80)) > -80) then
		if boss.rage < 262 and boss.health > 0 then
			boss.speed = boss.speed * 1.00008
			boss.rage = boss.rage + dt * 15
			boss.random = boss.random - 25 * dt
			boss.animation = bossattack_anim
		end
	end

	
	if boss.health <= 0 then
		boss.animation = bossdie_anim
		if boss.facetorightside == false then
			bossdie_anim:flipH()
		end
		if boss.animation.position == 15 then
			boss.animation:pause()
		end
	end
	
	
	
	
	-- Handle the collision with Boss (after calculate and subtract the excess of sprite) --
	if CheckCollision(tank.x, tank.y, images.tank_up:getWidth()*0.3, images.tank_up:getHeight()*0.3, boss.x + 185*0.6, boss.y + 82*0.6, 520*0.28*0.5, 420*0.52*0.5) and boss.health > 0 then
		LoadDefaultBoss()  -- if it tank_shield load default Boss this time --
		checkIfTankgetHit()
		
		-- tank_shield is not affect with the Boss, if player hit the boss then don't lose health but loss tank_shield --
		if tank.model == "tank_shield" then
			LoadDefault()
			itemTimeout = itemTimeout + 5
			tank.model = "tank_help"
		end
	end
	
	if lockdamagebombOnBoss == false then 
		if bomb_anim.position > 16 then
			if CheckCollision(bomb.x, bomb.y, costumeWidth * 0.8, costumeHeight * 0.8, boss.x + 130 , boss.y + 70, 520*0.35*0.7, 420*0.52*0.7) then
				boss.health = boss.health - 15
				lockdamagebombOnBoss = true  -- lock function to avoid Boss occur damage every frame --
			end
		end
	end
	
	for i = #ammos, 1, -1 do
		local ammo = ammos[i]
		if CheckCollision(ammo.x, ammo.y, 16 * 1.2, 16 * 1.2, boss.x + 115, boss.y + 30, 520*0.32*0.5, 420*0.73*0.5) then
			if ammo.damage == 1 then
				boss.health = boss.health - 2.5
			else
				boss.health = boss.health - 5
			end
			shoothit = {}
			if ammo.direction == "up" then
				shoothit.x = ammo.x - 15
				shoothit.y = ammo.y - 40
			elseif ammo.direction == "down" then   	
				shoothit.x = ammo.x	- 15			
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
	
	if boss.health <= 160 and bossfight2 == false and victory == false then
		bossfight2 = true
		warning_bossfight2 = 4 -- time warning to boss fight 2nd time --

		for i = 1, 360, 12 do
			bossbomb = {}
			bossbomb.x = boss.x + 200 * math.sin(math.pi * 2 * i / 360) + 100
			bossbomb.y = boss.y + 200 * math.cos(math.pi * 2 * i / 360) + 50
			bossbomb.anim = bossbomb_anim:clone()
			bossbomb.anim:pause()
			table.insert(bossbombs, bossbomb)
		end
	end
	
	-- If bossfight 2nd time, recall monster to fight with Boss in appear rate lower --
	if bossfight2 == true and warning_bossfight2 <= 0 then
		if lock_monster >= 10 then
			lock_monster = 6
		end
		if lock_monster >= 5 then 
		lock_monster = lock_monster - 5
		recallMonster()
		end
		if math.random(1,10000) == 1 then
		recallMonster()
		end
	end
	
	-- if boss health lower or equal to 0, win --
	checkWinCondition()
	
end

function BossDraw()
	-- draw bossbombs on main.lua for undertank purpose --
	
	-- draw bossbullets --
	if boss_time_appear <= 0 then
		for i = #bulletbosses, 1, -1 do
		local bulletboss = bulletbosses[i]
		love.graphics.draw(bulletboss.image, bulletboss.x + 145, bulletboss.y + 120, 0, 0.6, 0.6)
		end


		if boss.x > tank.x - 100 and boss.facetorightside == true then
			boss.facetorightside = false
			bossfire_anim:flipH()
			bossmove_anim:flipH()
			bossattack_anim:flipH()
		end 
		if boss.x < tank.x - 90 and boss.facetorightside == false then -- boss.x < "tank.x - 90", not "tank.x - 100" avoid flip repeatedly --
			boss.facetorightside = true
			bossfire_anim:flipH()
			bossmove_anim:flipH()
			bossattack_anim:flipH()
		end
		if boss.health <= 0 then 
			boss.facetorightside = nil     -- if boss die and fall animation start, don't flip --
		end
		
		boss.animation:draw(sprite, boss.x, boss.y, 0, 0.6, 0.6)
		
	end

	if boss_time_appear > 0 then 
		love.graphics.setColor(1,0.7,0.7)
	else
		love.graphics.setColor(0.9,0.9,0.9)
		love.graphics.rectangle("fill", 557, 49, 262, 11)
		if boss.rage < 262 then
			love.graphics.setColor(0, 1, 0)
			love.graphics.rectangle("fill", 557, 49, boss.rage, 11)
			love.graphics.setColor(1,0.2,0.2)
			love.graphics.rectangle("fill", 528, 32, boss.health, 20) -- bug if I don't set love.graphics.setColor(1, 1, 1) after it's affect to all screen red --
		else
			love.graphics.setColor(0.96, 0.23, 0.95)
			love.graphics.rectangle("fill", 557, 49, boss.rage, 11)
			love.graphics.setColor(0.78,0,0)
			love.graphics.rectangle("fill", 528, 32, boss.health, 20)
		end
		love.graphics.setColor(1, 1, 1)
	end
	love.graphics.draw(images.bosshealthbar, (fullscreenWidth - images.bosshealthbar:getWidth()) / 2, -20)

end

function LoadDefaultBoss()
	boss.speed = 31
	boss.rage = 0
	boss.random = 680
end


function checkWinCondition()
	if boss.health <= 0 then
		bossfight2 = false
		victory = true
	end
end



