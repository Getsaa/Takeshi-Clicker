require "modules.errHandler"
curOS = love.system.getOS()

    -- Load Libraries
    Timer = require "lib.timer"
    Gamestate = require "lib.gamestate"
    lovelyToasts = require "lib.lovelyToasts"
    lovesize = require "lib.lovesize"
    moonshine = require "lib.moonshine"

    -- Load Modules
	status = require "modules.status"
	audio = require "modules.audio"
	graphics = require "modules.graphics"

function love.load()
    -- Load Gamestates
    takeState = require "states.takeState"
    template = require "states.templateState"
    cubeState = require "states.cubeState"

    -- Load other stuff
    clicks = 0
	time = 0
    font = love.graphics.newFont("assets/fonts/metro.otf", 16)
    
    takeshiLoop = love.audio.newSource("assets/audio/music/takeshiLoop.ogg", "stream")
    takeshiLoop:setLooping(true)
    takeshiLoop:setVolume(0.5)

    cubeLoop = love.audio.newSource("assets/audio/music/cubeLoop.ogg", "stream")
    cubeLoop:setLooping(true)

	sfxHold = love.audio.newSource("assets/audio/sfx/hold.ogg", "static")
	sfxRelease = love.audio.newSource("assets/audio/sfx/release.ogg", "static")

    takeshiLoop:play()
    cubeLoop:play()

    -- Load the Gamestate lib
--    Gamestate.registerEvents()
    Gamestate.switch(takeState)
    
    -- Create a file to store the game's data
    love.filesystem.setIdentity("takeclicker")
    if not love.filesystem.getInfo("save") then
        love.filesystem.createDirectory("save")
    end
    if not love.filesystem.getInfo("save/save.take") then
        love.filesystem.write("save/save.take", "0")
    end
    if not love.filesystem.getInfo("save/time.take") then
        love.filesystem.write("save/time.take", "0")
    end

    clicks = love.filesystem.read("save/save.take")
	time = love.filesystem.read("save/time.take")

    effect =  moonshine(moonshine.effects.crt)
    bgfx = moonshine(moonshine.effects.scanlines)
    bgfx.scanlines.width = 3
    bgfx.scanlines.opacity = 0.2
end

function love.resize(width, height)
	lovesize.resize(width, height)
end

if curOS == "Windows" or "MacOS" or "Linux" then
	function love.keypressed(key)
		if key == "f1" then
			love.filesystem.createDirectory("screenshots")
			love.graphics.captureScreenshot("screenshots/" .. os.time() .. ".png")
			lovelyToasts.show("Screenshot taken", 3) -- Show toast for 3 seconds
		elseif key == "f2" then
			love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/screenshots")
			lovelyToasts.show("Opening the screenshots folder...", 3)
		elseif key == "f4" then
			-- Fullscreen toggle
			if love.window.getFullscreen() then
				love.window.setFullscreen(false)
			else
				love.window.setFullscreen(true)
			end
   		elseif key == "escape" then
   	     -- close the game and save the data
    	    Timer.after(1, function()
	            love.event.quit()
	        end)
	        lovelyToasts.show("Saving data...", 0.7)
   		elseif key == "space" then
        clicks = clicks + 1
		sfxHold:play()
		else
			Gamestate.keypressed(key)
		end
	end

	function love.mousepressed(x, y, button)
		if button == 1 then
			sfxHold:play()
			clicks = clicks + 1
		end
		if button == false then
			sfxRelease:play()
		end
	end
end

-- If the game is running on Android, then use the Android back button to quit the game
if curOS == "Android" then
	function love.keypressed(key)
		if key == "back" then
			-- close the game and save the data
			Timer.after(1, function()
				love.event.quit()
			end)
			lovelyToasts.show("Saving data...", 0.7)
		end
	end
	function love.touchpressed(id, x, y, dx, dy, pressure)
		if x > love.graphics.getWidth() / 2 then
			clicks = clicks + 1
		end
	end
end

if love.joystick.getJoystickCount() > 1 then
	local j = love.joystick.getJoysticks()[1]
	if j:isGamepad() then
		if j:isDown(2) then
			sfxHold:play()
			clicks = clicks + 1
		end
	end
end

function love.update(dt)
    dt = math.min(dt, 1 / 30)
	time = time + dt

    lovelyToasts.update(dt)
    if status.getNoResize() then
		Gamestate.update(dt)
	else
		love.graphics.setFont(font)
		graphics.screenBase(lovesize.getWidth(), lovesize.getHeight())
		graphics.setColor(1, 1, 1) -- Fade effect on
		Gamestate.update(dt)
		love.graphics.setColor(1, 1, 1) -- Fade effect off
		graphics.screenBase(love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setFont(font)
	end
    Timer.update(dt)

end

function love.draw()
    effect(function()
	bgfx(function()
    if status.getNoResize() then
		graphics.setColor(1, 1, 1) -- Fade effect on
		Gamestate.draw()
		love.graphics.setColor(1, 1, 1) -- Fade effect off
		love.graphics.setFont(font)
		if status.getLoading() then
--			love.graphics.print("Loading...", graphics.getWidth() - 175, graphics.getHeight() - 50)
			love.graphics.setColor(0, 0, 0, 0.5)
			love.graphics.rectangle("fill", 0, 0, 1280, 720)
			love.graphics.setColor(1, 1, 1)
			love.graphics.printf("Loading...", 0, graphics.getHeight() - 50, 1280, "center", 0, 1.3, 1.3)
		end
	else
		graphics.screenBase(lovesize.getWidth(), lovesize.getHeight())
		lovesize.begin()
			graphics.setColor(1, 1, 1) -- Fade effect on
			Gamestate.draw()
			love.graphics.setColor(1, 1, 1) -- Fade effect off
			love.graphics.setFont(font)

			if status.getLoading() then
--				love.graphics.print("Loading...", lovesize.getWidth() - 175, lovesize.getHeight() - 50)
				love.graphics.setColor(0, 0, 0, 0.5)
				love.graphics.rectangle("fill", 0, 0, 1280, 720)
				love.graphics.setColor(1, 1, 1)
				love.graphics.printf("Loading...", graphics.getWidth() - 175, graphics.getHeight() - 50, 1280, "center", 0, 1.3, 1.3)
			end
		lovesize.finish()
	end
    end)end)
    lovelyToasts.draw()
	graphics.screenBase(love.graphics.getWidth(), love.graphics.getHeight())
end

function love.quit()
	love.filesystem.write("save/save.take", clicks)
	love.filesystem.write("save/time.take", time)
end

function saveGame()
	love.filesystem.write("save/save.take", clicks)
	love.filesystem.write("save/time.take", time)
	lovelyToasts.show("Saving data...", 0.7)
end