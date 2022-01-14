# TankAndMonsters
a game using Lua with LÖVE
***Video Demo:  https://www.youtube.com/watch?v=S2W033R5QZM
***Description:

File in .exe https://drive.google.com/file/d/1fIma1FryqHruu39HDKqzu0cX-GWvU5tb/view?usp=sharing

Let take a look at codes (I left detail comments inside each file):
--- Folder assets : contain all images, sounds, and spritesheet of the game

--- conf.lua: set screen resolution, turn off Love2d fixbug console

--- anime8.lua: the library in Love2d for much easier to creat animation with spritesheet(I do not own that)

--- loadImagesandSounds.lua: load all images, sounds in folder asssets

--- menu.lua: display menu when start game, set buttons and instructions screen when read

--- boss.lua: contain variables of Boss(health, rage) and check collision Boss and tank

+ Boss move like zombie

+ Boss shoot like a shooter

+ Boss put bomb like bomber

+ If tank near bossbomb, bossbomb become mine and explode, bombBoss explode when total bombs equal 10 to 20 randomly

+ Handle the animation with Boss

+ Handle the collision with Boss (after calculateand subtract the excess of sprite)
+ If bossfight 2nd time, recall monster to fight

--- main.lua: the most important part in this game,
+ implement love.load when start game: load default variables, implement loadImagesandSounds.lua

+ implement love.update(pt) when play game:
When first time in game, you in menu and when you click start, the game will begin with menu.lua

*** There has 6 types of monster, have different characteristics and appear rate set by math.random()
+ Shooter: shoot bullet

+ Bomber: put bomb

+ Zombie: chase the tank

+ Troller: chase the tank with high speed if tank face it horizontaly

+ Mine: not move, explode when hit by bullet of shooter or bomb from bomber

+ Lucky: transform into item after time if not hit by tank

*** Check the move of tank, move of monster, the rate they use speacial skill

*** Items: has 6 items and 1 speacial item reduce rage of Boss to 0

*** Check collision of objects
Tank with other object of monsters,
Ammo of tank with monsters

+ implement love.draw: draw all object on screen

***
For the first time doing a real project, very first version of this game encounter a lot of bugs:
monsters not display damage it took as expected, tank damage in each frame,
even small deviation in variable names, then music playback error,..

After that, make the game balance neither too easy nor too hard, is also the difficult part of the project.
After 7 days of continuous hardwork, I finally finished it.

Thank CS50's Team!!! This will be the stepping stone for my growth!
Thank for CS50 team's hard work to create a wonderful course!!!
