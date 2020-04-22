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
			objectGrid[r][c] = display.newCircle(sceneGroup,(xx/size)*c, 200 + ((yy/size) - 100)*r, xx/size/2)

			objectGrid[r][c].anchorX = 1
			tempColor = colors[math.random(1,numColor)]
			objectGrid[r][c].color = tempColor

			if tempColor == "red" then
				objectGrid[r][c]:setFillColor(1,0,0)
				objectGrid[r][c].rgb = {1,0,0}
			elseif tempColor == "green" then
				objectGrid[r][c]:setFillColor(0,1,0)
				objectGrid[r][c].rgb = {0,1,0}
			elseif tempColor == "blue" then
				objectGrid[r][c]:setFillColor(0,0,1)
				objectGrid[r][c].rgb = {0,0,1}
			elseif tempColor == "yellow" then
				objectGrid[r][c]:setFillColor(0.9,0.9,0.2)
				objectGrid[r][c].rgb = {0.9,0.9,0.2}
			elseif tempColor == "purple" then
				objectGrid[r][c]:setFillColor(0.5,0.2,0.9)
				objectGrid[r][c].rgb = {0.5,0.2,0.9}
			elseif tempColor == "gray" then
				objectGrid[r][c]:setFillColor(0.5,0.5,0.5)
				objectGrid[r][c].rgb = {0.5,0.5,0.5}
			else --tempColor == "white"
				objectGrid[r][c]:setFillColor(1,1,1)
				objectGrid[r][c].rgb = {1,1,1}
			end

			objectGrid[r][c].row = r
			objectGrid[r][c].col = c
		end
	end

	local function findGroups(curTile, groups)
		local r = curTile.row
		local c = curTile.col
		local group
		if curTile.group == nil then --If the curTile is not in a group
			if c < size and objectGrid[r][c+1].color == curTile.color and objectGrid[r][c+1].group ~= nil then --If the tile to the right has the same color and is in a group
				group = groups[objectGrid[r][c+1].group] 
				table.insert(group, curTile) --Add current tile to the existing group
				curTile.group = objectGrid[r][c+1].group --Save what group it is in
				if r < size and objectGrid[r + 1][c].color == curTile.color then --If the tile below has the same color
					table.insert(group, objectGrid[r+1][c]) --Add it to the group it just joined
					objectGrid[r+1][c].group = curTile.group --Save what group it is in
				end
			else
				table.insert(groups, {curTile.color, curTile})  --Create a group for the curTile
				curTile.group = table.maxn(groups) --Save what group it is in
				group = groups[curTile.group]
				if r < size and objectGrid[r + 1][c].color == curTile.color then --If the tile below has the same color
					table.insert(group, objectGrid[r+1][c])
					objectGrid[r+1][c].group = curTile.group --Save what group it is in
				end
				if c < size and objectGrid[r][c+1].color == curTile.color then --If the tile to the right has the same color
					table.insert(group, objectGrid[r][c+1])
					objectGrid[r][c+1].group = curTile.group
				end
			end
		else --If the curTile is in a group
			group = groups[curTile.group]
			if r < size and objectGrid[r + 1][c].color == curTile.color then --If the tile below has the same color
				table.insert(group, objectGrid[r+1][c]) --Put into same group as current tile
				objectGrid[r+1][c].group = curTile.group --Save what group it is in
			end
			if c < size and objectGrid[r][c+1].color == curTile.color then --If the tile to the right has the same color
				if objectGrid[r][c+1].group ~= nil then --If the tile to the right is already in a group
					local newGroup = groups[objectGrid[r][c+1].group] --Change current group to existing group
					for i = table.maxn(group), 2, -1 do --Move all tiles to existing group
						table.insert(newGroup, table.remove(group, i))
					end
				else --If the tile to the right is not already in a group
					table.insert(group, objectGrid[r][c+1])
					objectGrid[r][c+1].group = curTile.group
				end
			end
		end
		return groups
	end

	local removed = false --Used to check if any groups were removed, if they have been the remove process should be ran
						  --again to get rid of any new groups that may have been spawned in
	local startRemove --Forward declared to be used in removeGroups to restart the removal process
	local playable = true --Disables the touch event while tiles are being removed/spawned

	local function removeGroups()
		local numRemovedFromCol = {0,0,0,0,0,0,0,0,0,0} --Tracks how many tiles are removed from each col
		for r=1,size do
			for c=1,size do
				local curTile = objectGrid[r][c]
				if curTile.group ~= nil then  --These are the tiles that will be removed
					numRemovedFromCol[curTile.col] = numRemovedFromCol[curTile.col] + 1
				end
			end
		end

		for c=1,size do
			local moveDownRows = {0,0,0,0,0,0,0,0,0,0} --Keeps track how many rows each tile should move down
			for r=size, 2, -1 do  -- Go through each column starting at the bottom and skip the top row
				local curTile = objectGrid[r][c]
				if curTile.group ~= nil then  --These tiles will be black and should get swapped with a colorful tile above it
					for row=r-1, 1, -1 do
						if objectGrid[row][c].group == nil then
							print("Col: "..c.." Row: "..row)
							moveDownRows[row] = moveDownRows[row] + 1
						end
					end
				end
			end
			for i=size, 1, -1 do
				local delta = moveDownRows[i]
				local curTile = objectGrid[i][c]
				local shiftTile = objectGrid[i + delta][c]
				shiftTile:setFillColor(curTile.rgb[1], curTile.rgb[2], curTile.rgb[3])
				shiftTile.color = curTile.color
				shiftTile.rgb = curTile.rgb
			end
		end

		for c=1,size do
			for r=1,numRemovedFromCol[c] do
				tempColor = colors[math.random(1,numColor)]
				objectGrid[r][c].color = tempColor

				if tempColor == "red" then
					objectGrid[r][c]:setFillColor(1,0,0)
					objectGrid[r][c].rgb = {1,0,0}
				elseif tempColor == "green" then
					objectGrid[r][c]:setFillColor(0,1,0)
					objectGrid[r][c].rgb = {0,1,0}
				elseif tempColor == "blue" then
					objectGrid[r][c]:setFillColor(0,0,1)
					objectGrid[r][c].rgb = {0,0,1}
				elseif tempColor == "yellow" then
					objectGrid[r][c]:setFillColor(0.9,0.9,0.2)
					objectGrid[r][c].rgb = {0.9,0.9,0.2}
				elseif tempColor == "purple" then
					objectGrid[r][c]:setFillColor(0.5,0.2,0.9)
					objectGrid[r][c].rgb = {0.5,0.2,0.9}
				elseif tempColor == "gray" then
					objectGrid[r][c]:setFillColor(0.5,0.5,0.5)
					objectGrid[r][c].rgb = {0.5,0.5,0.5}
				else --tempColor == "white"
					objectGrid[r][c]:setFillColor(1,1,1)
					objectGrid[r][c].rgb = {1,1,1}
				end
			end
		end
		if removed then
			timer.performWithDelay(500, startRemove)
			return;
		end
		playable = true
	end

	local function turnBlack() --Turns the grouped tiles black before they get replaced by new tiles
		for r=1,size do
			for c=1,size do
				local curTile = objectGrid[r][c]
				if curTile.group ~= nil then
					curTile:setFillColor(0,0,0)
					curTile.rgb = {0,0,0}
					curTile.color = "black"
				end
			end
		end
		removeGroups()
	end

	local function resetColors() --Changes tiles back to their original color from black
		for r=1,size do
			for c=1,size do
				local curTile = objectGrid[r][c]
				if curTile.group ~= nil then
					curTile:setFillColor(curTile.rgb[1], curTile.rgb[2], curTile.rgb[3])
				end
			end
		end
		timer.performWithDelay(500, turnBlack)
	end

	startRemove = function()
	    removed = false
		local groups = {}
		for r=1,size do
			for c=1,size do
				objectGrid[r][c].group = nil
			end
		end
		for r=1,size do
			for c=1,size do
				groups = findGroups(objectGrid[r][c], groups)
			end
		end
		for j, group in ipairs(groups) do
			local length = table.maxn(group)
			if length > 3 then  --If the group has at least 3 tiles (First element in group is the color)
				removed = true
				playable = false
				local message = "Color: "..group[1]
				for k=2, length do
					message = message.." Coord: ("..group[k].row..","..group[k].col..")"
					group[k]:setFillColor(0,0,0) --Change color to black
				end
				print(message)
			else
				for k=2, length do
					group[k].group = nil
				end
			end
		end
		if removed then --If no groups formed the removal process is done here
			timer.performWithDelay(500, resetColors) --Change color back to original and remove
		else
			playable = true --Since the removal process is done the board can be unlocked
		end
	end

	timer.performWithDelay(1000, startRemove) --Need to call once after spawning the initial tiles to check for groups

	local movedSoFar = 0

	local function move(event)
		if(event.phase == "began" and playable) then
			col = math.floor(event.x / 180) + 1
			row = math.floor((event.y-348) / 208) + 1
			if(row <= 0 or col <= 0 or row > size or col > size) then
				return
			end
			directionMoved = nil
			objectGrid[row][col].strokeWidth = 4
		elseif(event.phase == "moved" and playable) then
			if(row <= 0 or col <= 0 or row > size or col > size) then
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
			end

			if(directionMoved == 'x') then
				movedSoFar = (event.x - markX)
				--Note: 180 is the horizontal distance between 2 tiles
				if(movedSoFar > 180) then

					tempArray = {}
					for i=1,size do
						objectGrid[row][i].x = objectGrid[row][i].x + 180
						objectGrid[row][i].col = objectGrid[row][i].col + 1
						if(objectGrid[row][i].x > 1080) then
							objectGrid[row][i].x = objectGrid[row][i].x - 1080
							objectGrid[row][i].col = 1
						end
						tempArray[i] = objectGrid[row][i]
					end

					--Relocate each object in the grid
					for i=2,size do
						objectGrid[row][i] = nil
						objectGrid[row][i] = tempArray[i-1]
					end
					objectGrid[row][1] = tempArray[size]


					markX = markX + 180
					movedSoFar = 0

				elseif(movedSoFar < -180) then
					
					tempArray = {}
					for i=1,size do
						objectGrid[row][i].x = objectGrid[row][i].x - 180
						objectGrid[row][i].col = objectGrid[row][i].col - 1
						if(objectGrid[row][i].x < 100) then
							objectGrid[row][i].x = objectGrid[row][i].x + 1080
							objectGrid[row][i].col = 6
						end
						tempArray[i] = objectGrid[row][i]
					end

					--Relocate each object in the grid
					for i=1,size-1 do
						objectGrid[row][i] = nil
						objectGrid[row][i] = tempArray[i+1]
					end
					objectGrid[row][size] = tempArray[1]

					markX = markX - 180
					movedSoFar = 0

				end
			else
				movedSoFar = (event.y - markY)

				--Note: 220 is the vertical distance between
				if(movedSoFar > 220) then

					tempArray = {}
					for i=1,size do
						objectGrid[i][col].y = objectGrid[i][col].y + 220
						objectGrid[i][col].row = objectGrid[i][col].row + 1
						if(objectGrid[i][col].y > 1520) then
							objectGrid[i][col].y = 420
							objectGrid[i][col].row = 1
						end
						tempArray[i] = objectGrid[i][col]
					end

					--Relocate each object in the grid
					for i=2,size do
						objectGrid[i][col] = nil
						objectGrid[i][col] = tempArray[i-1]
					end
					objectGrid[1][col] = tempArray[size]


					markY = markY + 220
					movedSoFar = 0

				elseif(movedSoFar < -220) then
					tempArray = {}
					for i=1,size do
						objectGrid[i][col].y = objectGrid[i][col].y - 220
						objectGrid[i][col].row = objectGrid[i][col].row - 1
						if(objectGrid[i][col].y < 420) then
							objectGrid[i][col].y = 1520
							objectGrid[i][col].row = 6
						end
						tempArray[i] = objectGrid[i][col]
					end

					--Relocate each object in the grid
					for i=1,size-1 do
						objectGrid[i][col] = nil
						objectGrid[i][col] = tempArray[i+1]
					end
					objectGrid[size][col] = tempArray[1]


					markY = markY - 220
					movedSoFar = 0

				end
			end

		elseif(event.phase == "ended" and playable) then
			if(row <= 0 or col <= 0 or row > size or col > size) then
				return
			end
			for r=1,size do
				for c=1,size do
					objectGrid[r][c].strokeWidth = 0
				end
			end
			startRemove()
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