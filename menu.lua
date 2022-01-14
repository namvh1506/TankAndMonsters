-- Menu -- 
function menu()
	
	love.audio.play(sounds.menu)
	if lock_key < 1 then
		lock_key = lock_key + 0.009
	end
	if menu_theme == images.menu_newgame and lock_key >= 1 then
		if love.keyboard.isDown("space") then
			mainmenu = false
		elseif love.keyboard.isDown("down") and lock_key >= 1 then
			menu_theme = images.menu_instructions
			lockkey()
		elseif love.keyboard.isDown("up") and lock_key > 1 then
			menu_theme = images.menu_credit
			lockkey()
		end
	elseif menu_theme == images.menu_instructions then
		if love.keyboard.isDown("space") then
			menu_theme = images.instructions1
			in_read_instructions = true
			lockkey()
		elseif love.keyboard.isDown("up") and lock_key > 1 then
			menu_theme = images.menu_newgame
			lockkey()
		elseif love.keyboard.isDown("down") and lock_key >= 1 then
			menu_theme = images.menu_credit
			lockkey()
		end
	elseif menu_theme == images.menu_credit then
		if love.keyboard.isDown("space") then
			menu_theme = images.credit1
			lockkey()
		elseif love.keyboard.isDown("up") and lock_key >= 1 then
			menu_theme = images.menu_instructions
			lockkey()
		elseif love.keyboard.isDown("down") and lock_key >= 1 then
			menu_theme = images.menu_newgame
			lockkey()
		end
	end
	
	if menu_theme == images.credit1 then
		if love.keyboard.isDown("space") and lock_key >= 1 then
			menu_theme = images.credit2
			lockkey()
		end
	end
	if menu_theme == images.credit2 then
		if love.keyboard.isDown("space") and lock_key >= 1 then
			menu_theme = images.menu_newgame
			lockkey()
		end
	end
	
	if in_read_instructions == true then
		if love.keyboard.isDown("right") and lock_key >= 1 and instructions_no <= 6 then
			instructions_no = instructions_no + 1
			lockkey()
		elseif love.keyboard.isDown("left") and lock_key >= 1 and instructions_no >= 2 then
			instructions_no = instructions_no - 1
			lockkey()
		end
		read_instructions(instructions_no)
		if love.keyboard.isDown("space") and lock_key >= 1 then
			menu_theme = images.menu_newgame
			in_read_instructions = false
			lockkey()
			
		end
	end
	
end



function read_instructions(x)
	if x == 1 then
		menu_theme = images.instructions1  
	elseif x == 2 then
		menu_theme = images.instructions2
	elseif x == 3 then
		menu_theme = images.instructions3
	elseif x == 4 then
		menu_theme = images.instructions4 
	elseif x == 5 then
		menu_theme = images.instructions5 
	elseif x == 6 then
		menu_theme = images.instructions6
	elseif x == 7 then
		menu_theme = images.instructions7
	end
end

function lockkey()
	lock_key = lock_key - 1
end