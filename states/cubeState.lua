local angy = graphics.newImage(love.graphics.newImage(graphics.imagePath("cube")))
local bg = graphics.newImage(love.graphics.newImage(graphics.imagePath("cubeBG")))

angy.sizeX = 0.3
angy.sizeY = 0.3
speed = 7

return {
	enter = function(self, previous)
		graphics.setFade(0)
		graphics.fadeIn(0.5)
        takeshiLoop:setVolume(0)
        cubeLoop:setVolume(1)

        angy.x = 0
        angy.y = 0

        function enterAngy()
            Timer.tween(0, angy, {sizeX = 0}, "linear", function()
                  Timer.tween(0.5, angy, {sizeX = 0.3}, "linear", function()
                    end)
            end)
            Timer.tween(0, angy, {sizeY = 0}, "linear", function()
                Timer.tween(0.5, angy, {sizeY = 0.3}, "linear", function()
                    end)
            end)

            Timer.tween(0, bg, {sizeX = 1.4}, "linear", function()
                Timer.tween(0.5, bg, {sizeX = 1}, "out-quad", function()
                      end)
            end)
            Timer.tween(0, bg, {sizeY = 1.4}, "linear", function()
                Timer.tween(0.5, bg, {sizeY = 1}, "out-quad", function()
                      end)
            end)
        end

        function tweenHold()
            Timer.tween(0.1, angy, {sizeX = 0.25}, "out-quad", function() end)
            Timer.tween(0.1, angy, {sizeY = 0.25}, "out-quad", function() end)
        end

        function tweenRelease()
            Timer.tween(0.1, angy, {sizeX = 0.3}, "out-quad", function() end)
            Timer.tween(0.1, angy, {sizeY = 0.3}, "out-quad", function() end)
        end

        enterAngy()

	end,


	update = function(self, dt)
		if not graphics.isFading() then
			-- CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK
            if love.mouse.isDown(1) then
                tweenHold()
                Timer.tween(0.2, angy, {orientation = 0.02}, "out-quad", function() end)
            end
            if love.mouse.isDown(1) == false then
                tweenRelease()
                Timer.tween(0.2, angy, {orientation = 0}, "out-quad", function() end)
            end

            if love.keyboard.isDown("space") then
                tweenHold()
                Timer.tween(0.2, angy, {orientation = 0.02}, "out-quad", function() end)
            end
            if love.keyboard.isDown("space") == false then
                tweenRelease()
                Timer.tween(0.2, angy, {orientation = 0}, "out-quad", function() end)
            end

            -- Move the angy with the arrow keys
            if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
                Timer.tween(0.2, angy, {x = angy.x - speed}, "out-quad", function() end)
            end
            if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
                Timer.tween(0.2, angy, {x = angy.x + speed}, "out-quad", function() end)
            end
            if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
                Timer.tween(0.2, angy, {y = angy.y - speed}, "out-quad", function() end)
            end
            if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
                Timer.tween(0.2, angy, {y = angy.y + speed}, "out-quad", function() end)
            end

            -- Set the speed with the 1 and 2 keys
            if love.keyboard.isDown("1") then
                speed = speed - 0.1
            elseif love.keyboard.isDown("2") then
                speed = speed + 0.1
            end

            if speed < 1 then
                speed = 1
            elseif speed > 20 then
                speed = 20
            end

            if love.keyboard.isDown("3") then
                Timer.tween(0.04, angy, {x = 0}, "out-quad", function() end)
                Timer.tween(0.04, angy, {y = 0}, "out-quad", function() end)
            end
            if love.keyboard.isDown("4") then
                saveGame()
            end

			if not Gamestate.current().mousemoved then
				love.mouse.setVisible(true)
			end

            if love.keyboard.isDown("tab") then
                graphics.fadeOut(0.5, function()
                    Gamestate.switch(takeState)
                end)
                Timer.tween(0.5, angy, {sizeX = 0}, "in-quad", function() end)
                Timer.tween(0.5, angy, {sizeY = 0}, "in-quad", function() end)
            end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
            bg:draw()
            angy:draw()

            love.graphics.printf("Clicks: " .. clicks, -390, -290, 1280, "left", nil, 2, 2)
            love.graphics.printf("Playing as Cube | Press Tab to Switch", -390, -260, 1280, "left", nil, 1.3, 1.3)
            love.graphics.printf("Speed: " .. speed, -390, -235, 1280, "left", nil, 1, 1)
            love.graphics.printf("X: " .. math.floor(angy.x) .. " | Y: " .. math.floor(angy.y), -390, 275, 1280, "left", nil, 1, 1)
            love.graphics.printf("FPS: " .. love.timer.getFPS(), -390, 260, 1280, "left", nil, 1, 1)
            love.graphics.printf("Time Spent: " .. math.floor(time) .. " Seconds", -390, 245, 1280, "left", nil, 1, 1)
            love.graphics.push()
				love.graphics.setColor(1, 1, 1)
			love.graphics.pop()
		love.graphics.pop()
	end,


	leave = function(self)
		Timer.clear()
	end
}