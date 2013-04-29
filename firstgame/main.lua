-- Step 2, them go to step 3
physics = require("physics")
physics.start()
physics.setGravity(0, 9.8)


-- step 4c, then go to 5a
bananasEaten = 0
frameCounter = 1
bananaCount = 10

-- step 5b, then go to 6a
function vibrateBanana(event)
--	
	if(event.phase == "ended") then 
		print("vibrate called")
--
--		-- Vibrate mechanic
		system.vibrate()
--		
		event.target:removeSelf()
	end
--	
end


-- Step 6c
function onLocalCollision( self, event )
   if ( event.phase == "began" ) then
		if(self.myName == "banana") then 
			if(event.other.myName == "monkey") then
--			
				vx, vy = self:getLinearVelocity()
--				
				if(vy > 3) then 
					bananasEaten = bananasEaten + 1
					scoreText.text = tostring(bananasEaten)
					self.isVisible = false
					self:removeSelf()
				end
--					
			end
--			
--		
		end
	end
--	
end

-- Step 1, then go to step 2
local sky = display.newImage("clouds.png")
--	
local ground = display.newImage("ground.png")
ground.x = 160
ground.y = 445
physics.addBody(ground, {friction=0.5})
ground.bodyType = "static"
ground.myName = "ground"

local banana = display.newImage("banana.png")
banana.x = 180
banana.y = 80
banana.rotation = 10
physics.addBody(banana, {density = 2.0, friction = 1.5, bounce=0.3})
banana.myName = "banana"
banana:addEventListener("touch", vibrateBanana)

banana.collision = onLocalCollision
banana:addEventListener("collision", banana)

local monkey = display.newImage("monkey.png")
monkey.x = 180
monkey.y = 380
monkey.myName = "monkey"
physics.addBody(monkey, {density = 2.0, friction = 0.5, bounce=0.3})

local leftside = display.newImage("side.png")
leftside.x = 0
leftside.y = 400
physics.addBody(leftside, {friction=0.5})
leftside.bodyType = "static"
leftside.myName = "leftside"

local rightside = display.newImage("side.png")
rightside.x = 320
rightside.y = 400
physics.addBody(rightside, {friction=0.5})
rightside.bodyType = "static"
rightside.myName = "rightside"

scoreText = display.newText("0", 0, 0, native.systemFontBold, 16)
scoreText:setTextColor(0, 255, 255)
scoreText.x = 300
scoreText.y = 10

-- Accelerometer mechanic
local function onTilt( event )
	monkey.x = monkey.x + (10 * event.xGravity)
	monkey.y = monkey.y + (35 * event.yGravity * -1)


end


--
-- Step 4a, then go to 4b
local function onFrame(event)
	
-- 	
--	Step 4b, then go to 4c	
	frameCounter = frameCounter + 1
--	
	if(frameCounter % 40 == 0 and bananaCount > 0) then 
		bananaCount = bananaCount - 1
		local banana = display.newImage("banana.png")
		banana.x = math.random(0, 310)
		banana.y = 0
		banana.rotation = math.random(0, 360)
		physics.addBody(banana, {density = 2.0, friction = 1.5, bounce=0.01})
	   banana.myName = "banana"
--

--	   Step 5a, then go to 5b
	  banana:addEventListener("touch", vibrateBanana)

-- 	   Step 6b, then go to 6c
	   banana.collision = onLocalCollision
	   banana:addEventListener("collision", banana)
--
--
	-- Close the "if" statement for the counter
	end
--	
end


isSimulator = false

if("simulator" == system.getInfo("environment")) then 
	isSimulator = true
else
	isSimulator = false
end

-- Step 6c
function onSystemEvent(event)
	if(isSimulator == false) then

		if(event.type == "applicationExit") then
					os.exit()	
--				
		elseif(event.type == "applicationSuspend") then
					os.exit()
		elseif(event.type == "applicationResume") then
					os.exit()
--	 
		end
--		
	end
--
end

-- Step 3, then go to step 4a
Runtime:addEventListener("enterFrame", onFrame)

-- Step 6a, then go to 6b
Runtime:addEventListener("accelerometer", onTilt)
Runtime:addEventListener( "system", onSystemEvent)
