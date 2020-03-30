local composer = require( "composer" );
local scene = composer.newScene();
local myParams, sceneGroup;
local sizeDropDown, sizeTxt, colorDropDown, colorTxt

-- "scene:create()"
function scene:create( event )
	sceneGroup = self.view; -- The display group
	myParams = {}
	myParams.size = 6
	myParams.colors = 5
	
	local titleTxt = display.newText(sceneGroup, "Endless Mode", display.contentWidth / 2, display.contentHeight / 6)
	titleTxt.size = 150

	xx = display.contentWidth
	yy = display.contentHeight

	--Buliding size selection drop down menu
	local sizeDropDownArray = {}
	sizeDropDownArray.rect = {}
	sizeDropDownArray.txt = {}

	local sizeRectToHide = 10
	local function hideSizeDropDown()
		if sizeRectToHide == 5 then
			sizeRectToHide = 10
			sizeDropDown.isVisible = true
			sizeTxt.isVisible = true
			return
		end
		timer.performWithDelay (50, function()
				sizeDropDownArray.rect[sizeRectToHide].isVisible = false
				sizeDropDownArray.txt[sizeRectToHide].isVisible = false
				sizeRectToHide = sizeRectToHide - 1
				hideSizeDropDown()
			end, 1);
	end

	local function selectSize(event)
		myParams.size = event.target.val
		sizeTxt.text = "Game size: "..tostring(myParams.size)
		hideSizeDropDown()
	end

	for i=6,10 do
		sizeDropDownArray.rect[i] = display.newRect(sceneGroup,xx/2, (yy/2)-300+(100*(i-5)),500,100)
		sizeDropDownArray.rect[i].isVisible = false
		sizeDropDownArray.rect[i].val = i
		sizeDropDownArray.rect[i]:addEventListener("tap",selectSize)
		local str = tostring(i).."x"..tostring(i)
		sizeDropDownArray.txt[i] = display.newText(sceneGroup,str, xx/2, (yy/2)-300+(100*(i-5)))
		sizeDropDownArray.txt[i]:setFillColor(0,0,0)
		sizeDropDownArray.txt[i].isVisible = false
	end

	local sizeRectToShow = 6
	local function showSizeDropDown(event)
		sizeDropDown.isVisible = false
		sizeTxt.isVisible = false
		if sizeRectToShow == 11 then
			sizeRectToShow = 6
			return
		end

		timer.performWithDelay (50, function()
				sizeDropDownArray.rect[sizeRectToShow].isVisible = true
				sizeDropDownArray.txt[sizeRectToShow].isVisible = true
				sizeRectToShow = sizeRectToShow + 1
				showSizeDropDown(event)
			end, 1);
	end

	--Buliding color amount selection drop down menu
	local colorDropDownArray = {}
	colorDropDownArray.rect = {}
	colorDropDownArray.txt = {}

	local colorRectToHide = 7
	local function hideColorDropDown()
		if colorRectToHide == 4 then
			colorRectToHide = 7
			colorDropDown.isVisible = true
			colorTxt.isVisible = true
			return
		end
		timer.performWithDelay (50, function()
				colorDropDownArray.rect[colorRectToHide].isVisible = false
				colorDropDownArray.txt[colorRectToHide].isVisible = false
				colorRectToHide = colorRectToHide - 1
				hideColorDropDown()
			end, 1);
	end

	local function selectColors(event)
		myParams.colors = event.target.val
		colorTxt.text = "Different colors: "..tostring(myParams.colors)
		hideColorDropDown()
	end

	for i=5,7 do
		colorDropDownArray.rect[i] = display.newRect(sceneGroup, xx/2, (yy/2)+200+(100*(i-4)),450,100)
		colorDropDownArray.rect[i].isVisible = false
		colorDropDownArray.rect[i].val = i
		colorDropDownArray.rect[i]:addEventListener("tap",selectColors)
		local str = tostring(i).." colors"
		colorDropDownArray.txt[i] = display.newText(sceneGroup,str, xx/2, (yy/2)+200+(100*(i-4)))
		colorDropDownArray.txt[i]:setFillColor(0,0,0)
		colorDropDownArray.txt[i].isVisible = false
	end

	local colorRectToShow = 5
	local function showColorDropDown(event)
		colorDropDown.isVisible = false
		colorTxt.isVisible = false
		if colorRectToShow == 8 then
			colorRectToShow = 5
			return
		end

		timer.performWithDelay (50, function()
				colorDropDownArray.rect[colorRectToShow].isVisible = true
				colorDropDownArray.txt[colorRectToShow].isVisible = true
				colorRectToShow = colorRectToShow + 1
				showColorDropDown(event)
			end, 1);
	end

	sizeDropDown = display.newRect(sceneGroup, xx / 2, (yy / 2) - 200, 500, 100)
	sizeTxt = display.newText(sceneGroup, "Select game size", xx/2, (yy/2) - 200)
	sizeTxt:setFillColor(0,0,0)
	sizeDropDown:addEventListener("tap",showSizeDropDown)

	colorDropDown = display.newRect(sceneGroup, xx / 2, (yy / 2) + 300, 450, 100)
	colorTxt = display.newText(sceneGroup, "Select colors", xx/2, (yy/2) + 300)
	colorTxt:setFillColor(0,0,0)
	colorDropDown:addEventListener("tap",showColorDropDown)

	function gotoEndlessGame(event)
		composer.gotoScene("endlessGame", {effect="fade",time=500, params=myParams});
	end

	continueButton = display.newRect(sceneGroup,xx/2, yy-200, 200,100)
	continueButton:setFillColor(0.5,0.1,0.5)
	continueTxt = display.newText(sceneGroup, "Play!", xx/2,yy-200)
	continueTxt:setFillColor(1,1,1)
	continueButton:addEventListener("tap", gotoEndlessGame)
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