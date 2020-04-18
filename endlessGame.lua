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
			objectGrid[r][c] = display.newCircle(sceneGroup,(xx/size)*r, 200 + ((yy/size) - 100)*c, 75)
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

			objectGrid[r][c].row = c
			objectGrid[r][c].col = r
		end
	end

	local movedSoFar = 0

	function move(event)
		if(event.phase == "began") then
			print("Tapped at:",event.x,event.y)
			yPos = math.floor(event.x / 180) + 1
			xPos = math.floor((event.y-348) / 208) + 1
			if(xPos < 0 or yPos < 0 or xPos > size or yPos > size) then
				return
			end
			directionMoved = nil
			objectGrid[yPos][xPos].strokeWidth = 4
			print("tapped:",xPos,yPos)
			print("Row, Col: ",objectGrid[yPos][xPos].row,objectGrid[yPos][xPos].col)
		elseif(event.phase == "moved") then
			if(xPos < 0 or yPos < 0 or xPos > size or yPos > size) then
				return
			end
			if(directionMoved == nil) then
				xDif = math.abs(event.x - event.xStart)
				yDif = math.abs(event.y - event.yStart)
				if(xDif >= yDif) then
					directionMoved = 'x'
					markX = event.xStart
				else
					directionMoved = 'y'
					markY = event.yStart
				end
				print("Direction moved:",directionMoved)
			end

			if(directionMoved == 'x') then
				movedSoFar = movedSoFar + (event.x - markX)

				--Note: 180 is the horizontal distance between 2 tiles
				if(movedSoFar > 2000) then

					tempArray = {}
					for i=1,size do
						objectGrid[i][xPos].x = objectGrid[i][xPos].x + 180
						objectGrid[i][xPos].col = objectGrid[i][xPos].col + 1
						if(objectGrid[i][xPos].x > 1080) then
							objectGrid[i][xPos].x = objectGrid[i][xPos].x - 1080
							objectGrid[i][xPos].col = 1
						end
						tempArray[i] = objectGrid[i][xPos]
					end

					--Relocate each object in the grid
					for i=2,size do
						objectGrid[i][xPos] = nil
						objectGrid[i][xPos] = tempArray[i-1]
					end
					objectGrid[1][xPos] = tempArray[size]


					markX = markX + 180
					movedSoFar = 0

				elseif(movedSoFar < -2000) then
					
					tempArray = {}
					for i=1,size do
						objectGrid[i][xPos].x = objectGrid[i][xPos].x - 180
						objectGrid[i][xPos].col = objectGrid[i][xPos].col - 1
						if(objectGrid[i][xPos].x < 100) then
							objectGrid[i][xPos].x = objectGrid[i][xPos].x + 1080
							objectGrid[i][xPos].col = 6
						end
						tempArray[i] = objectGrid[i][xPos]
					end

					--Relocate each object in the grid
					for i=1,size-1 do
						objectGrid[i][xPos] = nil
						objectGrid[i][xPos] = tempArray[i+1]
					end
					objectGrid[size][xPos] = tempArray[1]

					markX = markX - 180
					movedSoFar = 0

				end
			else
				movedSoFar = movedSoFar + (event.y - markY)

				--Note: 220 is the vertical distance between
				if(movedSoFar > 2000) then

					tempArray = {}
					for i=1,size do
						objectGrid[yPos][i].y = objectGrid[yPos][i].y + 220
						objectGrid[yPos][i].row = objectGrid[yPos][i].row + 1
						if(objectGrid[yPos][i].y > 1520) then
							objectGrid[yPos][i].y = 420
							objectGrid[yPos][i].row = 1
						end
						tempArray[i] = objectGrid[yPos][i]
					end

					--Relocate each object in the grid
					for i=2,size do
						objectGrid[yPos][i] = nil
						objectGrid[yPos][i] = tempArray[i-1]
					end
					objectGrid[yPos][1] = tempArray[size]


					markY = markY + 220
					movedSoFar = 0


				elseif(movedSoFar < -2000) then
					--[[for i=1,size do
						objectGrid[yPos][i].y = objectGrid[yPos][i].y - 220
					end
					markY = markY - 220
					movedSoFar = 0]]

					tempArray = {}
					for i=1,size do
						objectGrid[yPos][i].y = objectGrid[yPos][i].y - 220
						objectGrid[yPos][i].row = objectGrid[yPos][i].row - 1
						if(objectGrid[yPos][i].y < 420) then
							objectGrid[yPos][i].y = 1520
							objectGrid[yPos][i].row = 6
						end
						tempArray[i] = objectGrid[yPos][i]
					end

					--Relocate each object in the grid
					for i=1,size-1 do
						objectGrid[yPos][i] = nil
						objectGrid[yPos][i] = tempArray[i+1]
					end
					objectGrid[yPos][size] = tempArray[1]


					markY = markY - 220
					movedSoFar = 0

				end
			end

		elseif(event.phase == "ended") then
			if(xPos < 0 or yPos < 0 or xPos > size or yPos > size) then
				return
			end
			for r=1,size do
				for c=1,size do
					objectGrid[r][c].strokeWidth = 0
				end
			end
		end
	end

	Runtime:addEventListener("touch",move)

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