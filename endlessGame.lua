local composer = require( "composer" );
local scene = composer.newScene();
local myParams, sceneGroup;
local size, colors

-- "scene:create()"
function scene:create( event )
	sceneGroup = self.view; -- The display group
	myParams = event.params
	size = myParams.size
	numColor = myParams.colors

	xx = display.contentWidth
	yy = display.contentHeight

	titleTxt = display.newText(sceneGroup, "Endless mode!", xx/2, 100)
	titleTxt.size = 75

	scoreTitle = display.newText(sceneGroup, "Score:", xx/2 - 50, 175)

	scoreVal = display.newText(sceneGroup, "0", xx/2 + 50, 175)

	objectGrid = {}

	if numColor == 5 then
		colors = {"red","blue","green","yellow","purple"}
	elseif numColor == 6 then
		colors = {"red","blue","green","yellow","purple", "gray"}
	else --colors == 7
		colors = {"red","blue","green","yellow","purple", "gray", "white"}
	end

	for r=1,size do
		objectGrid[r] = {}
		for c=1,size do
			objectGrid[r][c] = display.newCircle(sceneGroup,(xx/size)*r, 200 + ((yy/size) - 100)*c, 50)
			objectGrid[r][c].anchorX = 1
			tempColor = colors[math.random(1,numColor)]
			objectGrid[r][c].color = tempColor

			if tempColor == "red" then
				objectGrid[r][c]:setFillColor(1,0,0)
			elseif tempColor == "blue" then
				objectGrid[r][c]:setFillColor(0,1,0)
			elseif tempColor == "green" then
				objectGrid[r][c]:setFillColor(0,0,1)
			elseif tempColor == "yellow" then
				objectGrid[r][c]:setFillColor(0.9,0.9,0.2)
			elseif tempColor == "purple" then
				objectGrid[r][c]:setFillColor(0.5,0.2,0.9)
			elseif tempColor == "gray" then
				objectGrid[r][c]:setFillColor(0.5,0.5,0.5)
			else --temeColor == "white"
				objectGrid[r][c]:setFillColor(1,1,1)
			end

			objectGrid[r][c].row = r
			objectGrid[r][c].col = c
		end
	end

end

-- "scene:show()"
function scene:show( event )
	local phase = event.phase;
	if ( phase == "will" ) then
		-- Called when the scene is still off screen
		-- (but is about to come on screen).
	elseif ( phase == "did" ) then
		-- Called when the scene is now on screen.
		-- Insert code here to make the scene come alive.
		-- Example: start timers, begin animation, play audio, etc.
	end
end

-- "scene:hide()"
function scene:hide( event )
	local phase = event.phase;
	if ( phase == "will" ) then
		-- Called when the scene is on screen
		-- (but is about to go off screen).
		-- Insert code here to "pause" the scene.
		-- Example: stop timers, stop animation, stop audio, etc.
	elseif ( phase == "did" ) then
		-- Called immediately after scene goes off screen.
	end
end

-- "scene:destroy()"
function scene:destroy( event )
	-- Called prior to the removal of scene's view("sceneGroup").
	-- Insert code here to clean up the scene.
	-- Example: remove display objects, save state, etc.
end

-- Listeners (put at bottom of scene.lua file, along with above)
scene:addEventListener( "create", scene );
scene:addEventListener( "show", scene );
scene:addEventListener( "hide", scene );
scene:addEventListener( "destroy", scene );
return scene;

--move function:
--[[
	local function move(event)
		if event.phase == "began" then
			event.target.markX = event.target.x
			event.target.markY = event.target.y
		elseif event.phase == "moved" then
				--The first time the app ran, it was throwing an error about 
						--markX, later times it ran fine, but these nil statements fixed it
			if event.target.markX == nil then
				event.target.markX = display.contentWidth / 2
			end
			if event.target.markY == nil then
				event.target.markY = display.contentHeight / 2
			end
			local x = (event.x - event.xStart) + event.target.markX
			local y = (event.y - event.yStart) + event.target.markY
			xx = display.contentWidth
			yy = display.contentHeight
			if not (x<100 or y>(yy-100) or y<100 or x>(xx-100)) then
				event.target.x = x
				event.target.y = y
			end
		end
	end
	obj:addEventListener("touch", move)
]]