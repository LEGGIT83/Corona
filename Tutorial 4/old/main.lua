display.setStatusBar(display.HiddenStatusBar)
local sprite = require("sprite")

local backbackground = display.newImage("background.png")
backbackground.x = 240
backbackground.y = 160

local backgroundfar = display.newImage("bgfar1.png")
backgroundfar.x = 480
backgroundfar.y = 160

local backgroundnear1 = display.newImage("bgnear2.png")
backgroundnear1.x = 240
backgroundnear1.y = 160

local backgroundnear2 = display.newImage("bgnear2.png")
backgroundnear2.x = 760
backgroundnear2.y = 160

local blocks = display.newGroup()
local player = display.newGroup()
local screen = display.newGroup()

local groundMin = 420
local groundMax = 340
local groundLevel = groundMin
local speed = 5

for a = 1, 8, 1 do

	isDone = false
	numGen = math.random(2)
	local newBlock
	print (numGen)
	if(numGen == 1 and isDone == false) then
		newBlock = display.newImage("ground1.png")
		isDone = true
	end
	
	if(numGen == 2 and isDone == false) then
		newBlock = display.newImage("ground2.png")
		isDone = true
	end
	
	if(numGen == 3 and isDone == false) then
		newBlock = display.newImage("ground3.png")
		isDone = true
	end
	
	if(isDone == false) then
		newBlock = display.newImage("ground1.png")
	end
	newBlock.name = ("block" .. a)
	newBlock.id = a
	newBlock.x = (a * 79) - 79
	newBlock.y = groundLevel
	blocks:insert(newBlock)
end

--create our sprite sheet
local spriteSheet = sprite.newSpriteSheet("monsterSpriteSheet.png", 100, 100)
local monsterSet = sprite.newSpriteSet(spriteSheet, 1, 7)
sprite.add(monsterSet, "running", 1, 6, 600, 0)
sprite.add(monsterSet, "jumping", 7, 7, 1, 1)
--set the different variables we will use for our monster sprite
--also sets and starts the first animation for the monster
local monster = sprite.newSprite(monsterSet)
monster:prepare("running")
monster:play()
monster.x = 110
monster.y = 200
--these are 2 variables that will control the falling and jumping of the monster
monster.gravity = -6
monster.accel = 0
--rectangle used for our collision detection
--it will always be in front of the monster sprite
--that way we know if the monster hit into anything
local collisionRect = display.newRect(monster.x + 36, monster.y, 1, 70)
collisionRect.strokeWidth = 1
collisionRect:setFillColor(140, 140, 140)
collisionRect:setStrokeColor(180, 180, 180)
collisionRect.alpha = 0
--used to put everything on the screen into the screen group
--this will let us change the order in which sprites appear on
--the screen if we want. The earlier it is put into the group the
--further back it will go
screen:insert(backbackground)
screen:insert(backgroundfar)
screen:insert(backgroundnear1)
screen:insert(backgroundnear2)
screen:insert(blocks)
screen:insert(monster)
screen:insert(collisionRect)


--the update function will control most everything that happens in our game
--this will be called every frame(30 frames per second in our case(the default in corona))
local function update( event )
    updateBackgrounds()
    updateSpeed()
    updateMonster()
    updateBlocks()
    checkCollisions()
end

function checkCollisions()
     wasOnGround = onGround
     --checks to see if the collisionRect has collided with anything. This is why it is lifted off of the ground
     --a little bit, if it hits the ground that means we have run into a wall. We check this by cycling through
     --all of the ground pieces in the blocks group and comparing their x and y coordinates to that of the collisionRect
     for a = 1, blocks.numChildren, 1 do
          if(collisionRect.y - 10 > blocks[a].y - 170 and blocks[a].x - 40 < collisionRect.x and blocks[a].x + 40 > collisionRect.x) then
               speed = 0
          end
     end
     --this is where we check to see if the monster is on the ground or in the air, if he is in the air then he can't jump(sorry no double
     --jumping for our little monster, however if you did want him to be able to double jump like Mario then you would just need
     --to make a small adjustment here, by adding a second variable called something like hasJumped. Set it to false normally, and turn it to
     --true once the double jump has been made. That way he is limited to 2 hops per jump.
     --Again we cycle through the blocks group and compare the x and y values of each.
     for a = 1, blocks.numChildren, 1 do
          if(monster.y >= blocks[a].y - 170 and blocks[a].x < monster.x + 60 and blocks[a].x > monster.x - 60) then
               monster.y = blocks[a].y - 171
               onGround = true
               break
          else
               onGround = false
          end
     end
end

function updateMonster()
     --if our monster is jumping then switch to the jumping animation
     --if not keep playing the running animation
     if(onGround) then
          --if we are alread on the ground we don't need to prepare anything new
          if(wasOnGround) then
          else
               monster:prepare("running")
               monster:play()
          end
     else
          monster:prepare("jumping")
          monster:play()
     end
     if(monster.accel > 0) then
          monster.accel = monster.accel - 1
     end
     --update the monsters position accel is used for our jump and
     --gravity keeps the monster coming down. You can play with those 2 variables
     --to make lots of interesting combinations of gameplay like 'low gravity' situations
     monster.y = monster.y - monster.accel
     monster.y = monster.y - monster.gravity
     --update the collisionRect to stay in front of the monster
     collisionRect.y = monster.y
end
--this is the function that handles the jump events. If the screen is touched on the left side
--then make the monster jump
function touched( event )
     if(event.phase == "began") then
          if(event.x < 241) then
               if(onGround) then
                    monster.accel = monster.accel + 20
               end
          end
     end
end

function updateSpeed()
	speed = speed + .05
end

function updateBlocks()
	for a = 1, blocks.numChildren, 1 do
								
		if(a > 1) then
			newX = (blocks[a - 1]).x + 79
		else
			newX = (blocks[8]).x + 79 - speed
		end
		
		if((blocks[a]).x < -40) then
			(blocks[a]).x, (blocks[a]).y = newX, (blocks[a]).y			
		else
			(blocks[a]):translate(speed * -1, 0)
		end		
		
	end
end

function updateBackgrounds()
	--far background movement
	backgroundfar.x = backgroundfar.x - (speed/55)
	
	--near background movement
	backgroundnear1.x = backgroundnear1.x - (speed/5)
	if(backgroundnear1.x < -239) then
		backgroundnear1.x = 760
	end
	
	backgroundnear2.x = backgroundnear2.x - (speed/5)
	if(backgroundnear2.x < -239) then
		backgroundnear2.x = 760
	end
end

--this is how we call the update function, make sure that this line comes after the actual function or it will not be able to find it
--timer.performWithDelay(how often it will run in milliseconds, function to call, how many times to call(-1 means forever))
timer.performWithDelay(1, update, -1)
Runtime:addEventListener("touch", touched, -1)