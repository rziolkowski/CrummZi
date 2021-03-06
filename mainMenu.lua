local composer = require( "composer" );
local widget = require( "widget" )
local scene = composer.newScene();
local myParams;
local sceneGroup;

-- "scene:create()"
function scene:create( event )
	sceneGroup = self.view; -- The display group
	myParams = event.params

	local titleTxt = display.newText(sceneGroup, "CrummZi!", display.contentWidth / 2, display.contentHeight / 6)
	titleTxt.size = 200
	titleTxt:setFillColor(0.5,0.1,1)

	function gotoSetup(event)
		composer.gotoScene("setUpPage", {effect="fade",time=500});
	end

	local playButton = display.newRect(sceneGroup, display.contentWidth / 2, display.contentHeight / 2, 400, 150)
	playButton:setFillColor(0.5,0.1,1)
	playButton:addEventListener("tap", gotoSetup)

	local btnTxt = display.newText(sceneGroup, "Play!", display.contentWidth / 2, display.contentHeight / 2)
	btnTxt.size = 100

end

-- "scene:show()"
function scene:show( event )
	sceneGroup = self.view;
	local phase = event.phase;
	if ( phase == "will" ) then
		-- Called when the scene is still off screen
		-- (but is about to come on screen).
		sceneGroup.isVisible = true
	elseif ( phase == "did" ) then
		-- Called when the scene is now on screen.
		-- Insert code here to make the scene come alive.
		-- Example: start timers, begin animation, play audio, etc.
	end
end

-- "scene:hide()"
function scene:hide( event )
	sceneGroup = self.view;
	local phase = event.phase;
	if ( phase == "will" ) then
		-- Called when the scene is on screen
		-- (but is about to go off screen).
		-- Insert code here to "pause" the scene.
		-- Example: stop timers, stop animation, stop audio, etc.
	elseif ( phase == "did" ) then
		-- Called immediately after scene goes off screen.
		sceneGroup.isVisible = false
	end
end

-- "scene:destroy()"
function scene:destroy( event )
	sceneGroup = self.view;
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