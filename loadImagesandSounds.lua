-- LoadImage --
function LoadImages()
	images = {}
	
	-- Load defauft set --
	
	images.menu_newgame = love.graphics.newImage("assets/menu/menu_newgame.png")
	images.menu_instructions = love.graphics.newImage("assets/menu/menu_instructions.png")
	images.menu_credit = love.graphics.newImage("assets/menu/menu_credit.png")
	
	images.credit1 = love.graphics.newImage("assets/menu/credit1.png")
	images.credit2 = love.graphics.newImage("assets/menu/credit2.png")
	
	images.instructions1 = love.graphics.newImage("assets/menu/instructions1.png")
	images.instructions2 = love.graphics.newImage("assets/menu/instructions2.png")
	images.instructions3 = love.graphics.newImage("assets/menu/instructions3.png")
	images.instructions4 = love.graphics.newImage("assets/menu/instructions4.png")
	images.instructions5 = love.graphics.newImage("assets/menu/instructions5.png")
	images.instructions6 = love.graphics.newImage("assets/menu/instructions6.png")
	images.instructions7 = love.graphics.newImage("assets/menu/instructions7.png")
	
	
	images.background = love.graphics.newImage("assets/background.png")
	
	images.monster_zombie = love.graphics.newImage("assets/monsters/zombie.png")
	images.monster_shooter = love.graphics.newImage("assets/monsters/shooter.png")
	images.monster_bomber = love.graphics.newImage("assets/monsters/bomber.png")
	images.monster_troller = love.graphics.newImage("assets/monsters/troller.png")
	images.monster_mine = love.graphics.newImage("assets/monsters/mine.png")
	images.monster_lucky = love.graphics.newImage("assets/monsters/lucky.png")
	
	images.tank_up = love.graphics.newImage("assets/tankup.png")
	images.tank_down = love.graphics.newImage("assets/tankdown.png")
	images.tank_left = love.graphics.newImage("assets/tankleft.png")
	images.tank_right = love.graphics.newImage("assets/tankright.png")
	
	images.gun_up = love.graphics.newImage("assets/gunup.png")
	images.gun_down = love.graphics.newImage("assets/gundown.png")
	images.gun_left = love.graphics.newImage("assets/gunleft.png")
	images.gun_right = love.graphics.newImage("assets/gunright.png")
	
	images.item_1 = love.graphics.newImage("assets/items/addbomb.png")
	images.item_2 = love.graphics.newImage("assets/items/ammo.png")
	images.item_3 = love.graphics.newImage("assets/items/hp.png")
	images.item_4 = love.graphics.newImage("assets/items/nonreload.png")
	images.item_5 = love.graphics.newImage("assets/items/shield.png")
	images.item_6 = love.graphics.newImage("assets/items/speed.png")
	images.item_7 = love.graphics.newImage("assets/items/calmdown.png")
	
	images.over_screen = love.graphics.newImage("assets/overscreen.png")
	images.victory = love.graphics.newImage("assets/victory.png")
	
	-- Load tankhelp when tank damage --
	images.tankhelp_up = love.graphics.newImage("assets/costumes/tankhelpup.png")
	images.tankhelp_down = love.graphics.newImage("assets/costumes/tankhelpdown.png")
	images.tankhelp_left = love.graphics.newImage("assets/costumes/tankhelpleft.png")
	images.tankhelp_right = love.graphics.newImage("assets/costumes/tankhelpright.png")
	
	images.gunhelp_up = love.graphics.newImage("assets/costumes/gunhelpup.png")
	images.gunhelp_down = love.graphics.newImage("assets/costumes/gunhelpdown.png")
	images.gunhelp_left = love.graphics.newImage("assets/costumes/gunhelpleft.png")
	images.gunhelp_right = love.graphics.newImage("assets/costumes/gunhelpright.png")
	

	images.ammo_up = love.graphics.newImage("assets/ammoup.png")
	images.ammo_down = love.graphics.newImage("assets/ammodown.png")
	images.ammo_left = love.graphics.newImage("assets/ammoleft.png")
	images.ammo_right = love.graphics.newImage("assets/ammoright.png")
	
	images.ammobig_up = love.graphics.newImage("assets/ammobigup.png")
	images.ammobig_down = love.graphics.newImage("assets/ammobigdown.png")
	images.ammobig_left = love.graphics.newImage("assets/ammobigleft.png")
	images.ammobig_right = love.graphics.newImage("assets/ammobigright.png")
	
	
	-- Load images tank and gun on shield --
	images.tankshield_up = love.graphics.newImage("assets/costumes/tankshieldup.png")
	images.tankshield_down = love.graphics.newImage("assets/costumes/tankshielddown.png")
	images.tankshield_left = love.graphics.newImage("assets/costumes/tankshieldleft.png")
	images.tankshield_right = love.graphics.newImage("assets/costumes/tankshieldright.png")
	
	images.gunshield_up = love.graphics.newImage("assets/costumes/gunshieldup.png")
	images.gunshield_down = love.graphics.newImage("assets/costumes/gunshielddown.png")
	images.gunshield_left = love.graphics.newImage("assets/costumes/gunshieldleft.png")
	images.gunshield_right = love.graphics.newImage("assets/costumes/gunshieldright.png")
	
	-- Load images gun on item --
	images.gunpower_up = love.graphics.newImage("assets/costumes/gunpowerup.png")
	images.gunpower_down = love.graphics.newImage("assets/costumes/gunpowerdown.png")
	images.gunpower_left = love.graphics.newImage("assets/costumes/gunpowerleft.png")
	images.gunpower_right = love.graphics.newImage("assets/costumes/gunpowerright.png")
	
	images.gunnonreload_up = love.graphics.newImage("assets/costumes/gunnonreloadup.png")
	images.gunnonreload_down = love.graphics.newImage("assets/costumes/gunnonreloaddown.png")
	images.gunnonreload_left = love.graphics.newImage("assets/costumes/gunnonreloadleft.png")
	images.gunnonreload_right = love.graphics.newImage("assets/costumes/gunnonreloadright.png")
	
	-- Load warning on low health --
	images.warningon = love.graphics.newImage("assets/warningon.png")
	images.warningoff = love.graphics.newImage("assets/warningoff.png")
	
	-- Bomb explode --
	images.explode = love.graphics.newImage("assets/explode.png")
	
	-- Load bosswarning image --
	images.bosswarning1 = love.graphics.newImage("assets/boss/bosswarning1.png")
	images.bosswarning2 = love.graphics.newImage("assets/boss/bosswarning2.png")
	images.noenter = love.graphics.newImage("assets/boss/noenter.png")
	
	-- key to the boss --
	images.key = love.graphics.newImage("assets/boss/bosskey.png")
	images.boss2 = love.graphics.newImage("assets/boss/boss2.png")
	
		
end


function LoadSounds()

	sounds = {}
	
	sounds.menu = love.audio.newSource("assets/sound/menu.mp3", "stream")
	sounds.switchmenu = love.audio.newSource("assets/sound/switchmenu.mp3", "static")
	
	sounds.start = love.audio.newSource("assets/sound/start.mp3", "stream")  -- Music of XForce java game by Teamobi --
	sounds.scorehalf = love.audio.newSource("assets/sound/scorehalf.mp3", "stream")
	sounds.boss1 = love.audio.newSource("assets/sound/boss1.mp3", "stream") -- Music of Metal Slug game by SNK --
	sounds.boss2 = love.audio.newSource("assets/sound/boss2.mp3", "stream")
	sounds.lose = love.audio.newSource("assets/sound/lose.mp3", "stream")
	sounds.victory = love.audio.newSource("assets/sound/victory.mp3", "stream")
	
	sounds.bomb = love.audio.newSource("assets/sound/bomb.mp3", "static")
	sounds.ammo = love.audio.newSource("assets/sound/ammo.mp3", "static")
	sounds.nonreloadammo = love.audio.newSource("assets/sound/nonreloadammo.mp3", "static")
	sounds.bigammo = love.audio.newSource("assets/sound/bigammo.mp3", "static")
	sounds.reload = love.audio.newSource("assets/sound/reload.mp3", "static")
	sounds.mine = love.audio.newSource("assets/sound/mine.mp3", "static")
	sounds.item = love.audio.newSource("assets/sound/item.mp3", "static")
	sounds.monsterexplode = love.audio.newSource("assets/sound/monsterexplode.mp3", "static")
	sounds.tire = love.audio.newSource("assets/sound/tire.mp3", "static")
	
	
	sounds.bossalarm = love.audio.newSource("assets/sound/bossalarm.mp3", "stream")
	sounds.alarm = love.audio.newSource("assets/sound/alarm.mp3", "static")
	sounds.takedamage = love.audio.newSource("assets/sound/takedamage.mp3", "static")
	
	
end

function playSounds()

	if score == 0 then
		love.audio.stop(sounds.menu)
		love.audio.play(sounds.start)
	elseif score >= scoretowin_half then
		love.audio.stop(sounds.start)
		love.audio.play(sounds.scorehalf)
	end
		
	if boss_key == true then
		love.audio.stop(sounds.scorehalf)
		love.audio.play(sounds.boss1)
	end

	
	if bomb_anim.position == 14 then
		love.audio.play(sounds.bomb)
	end
	
	if bossfight2 == true then
		love.audio.stop(sounds.start, sounds.scorehalf, sounds.boss1)
		love.audio.play(sounds.boss2)
	end
	
	for i = #mines, 1, -1 do
		local mine = mines[i]
		if mine.anim.position == 1 then
			love.audio.play(sounds.mine)
		end
	end
	
end