local titleBG = graphics.newImage(love.graphics.newImage(graphics.imagePath("icon")))

return {
	enter = function(self, previous)

		graphics.setFade(0)
		graphics.fadeIn(0.5)
		
	end,


	update = function(self, dt)
		if not graphics.isFading() then
			

			if not Gamestate.current().mousemoved then
				love.mouse.setVisible(true)
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			titleBG:draw()

			love.graphics.push()
				love.graphics.setColor(1, 1, 1)
				love.graphics.printf("the", -640, 350, 1280, "center", nil, 1, 1)
			love.graphics.pop()
		love.graphics.pop()
	end,


	leave = function(self)
		Timer.clear()
	end
}