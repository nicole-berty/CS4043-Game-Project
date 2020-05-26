--Level 3
local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()
physics.setGravity(0, 0)

local Doggo, background
local Path1, Path2, Path3, Path4, Path5, Path6, Path7, Path8, Path9, Path10
local drag_direction, bounds
local redZone, redZone1, redZone2, redZone3, redZone5, redZone6, redZone7, redZone8, redZone9, greenZone1, GrassyArea
local time = 403
local timeText
local gameOverSound
local StartingPosition, StartingPosition1
local Start = "begin"
local Objective
local d = 'up'
local a = 'up'
local s = 'up'
local w = 'up'
local up = 'up'
local down = 'up'
local space = 'up'
local right = 'up'
local left = 'up'
local d1 = 'up'
local a1 = 'up'
local s1 = 'up'
local w1 = 'up'
local up1 = 'up'
local down1 = 'up'
local space1 = 'up'
local right1 = 'up'
local left1 = 'up'
local terenceTimer
local Startx, Starty, Currentx, Currenty
local moveX, moveY
local disableControls = "Enabled"
local moveStart = 1

local pauseButton

function scene:resumeGame(event)
    physics.start()
    disableControls = "Disabled"
    audio.resume(1)
    timer.resume( terenceTimer )
end

local function pause()
    local options = {
        isModal = true,
        effect = "fade",
        time = 400
    }
    Runtime:removeEventListener("enterFrame", gameLoop)
    Runtime:removeEventListener("key", movementKeys)
    Runtime:removeEventListener("enterFrame", walkPerson)
    Runtime:removeEventListener("collision" , onPathCollision)
    Runtime:removeEventListener("enterFrame", dragDoggo)
    Runtime:removeEventListener("enterFrame", pathDrag)
    disableControls = "Enabled"
    timer.pause( terenceTimer )
    physics.pause()
    audio.pause(1)
    composer.showOverlay( "Menus.pauseGame", options )
end

local function endGame()
    audio.play(gameOverSound)
    composer.gotoScene("Menus.GameOver", { time = 200, effect = "crossFade"})
end

local function nextLevel()
    composer.gotoScene("Level4.Level4Cutscene", { time = 800, effect = "crossFade"})
end

local function hideScents()
    Path1.isVisible = false
    Path2.isVisible = false
    Path3.isVisible = false
    Path4.isVisible = false
    Path5.isVisible = false
    Path6.isVisible = false
    Path7.isVisible = false
    Path8.isVisible = false
    Path9.isVisible = false
    Path10.isVisible = false
    redZone.isVisible = false
    redZone1.isVisible = false
    redZone2.isVisible = false
    redZone3.isVisible = false
    redZone4.isVisible = false
    redZone5.isVisible = false
    redZone6.isVisible = false
    redZone7.isVisible = false
    redZone8.isVisible = false
    redZone9.isVisible = false
    greenZone.isVisible = false
    greenZone1.isVisible = false
    GrassyArea.isVisible = false
    StartingPosition.isVisible = true
end


--Function that moves the map
local function moveTilesUp()
    background.y = background.y + 8
    Path1.y = Path1.y + 8
    Path2.y = Path2.y + 8
    Path3.y = Path3.y + 8
    Path4.y = Path4.y + 8
    Path5.y = Path5.y + 8
    Path6.y = Path6.y + 8
    Path7.y = Path7.y + 8
    Path8.y = Path8.y + 8
    Path9.y = Path9.y + 8
    Path10.y = Path10.y + 8
    redZone.y = redZone.y + 8
    redZone1.y = redZone1.y + 8
    redZone2.y = redZone2.y + 8
    redZone3.y = redZone3.y + 8
    redZone4.y = redZone4.y + 8
    redZone5.y = redZone5.y + 8
    redZone6.y = redZone6.y + 8
    redZone7.y = redZone7.y + 8
    redZone8.y = redZone8.y + 8
    redZone9.y = redZone9.y + 8
    greenZone1.y = greenZone1.y + 8
    GrassyArea.y = GrassyArea.y + 8
    StartingPosition.y = StartingPosition.y + 8
    StartingPosition1.y = StartingPosition1.y + 8
    Objective.y = Objective.y + 8
    greenZone.y = greenZone.y + 8
end

--Function that moves the map
local function moveTilesDown()
    background.y = background.y - 8
    Path1.y = Path1.y - 8
    Path2.y = Path2.y - 8
    Path3.y = Path3.y - 8
    Path4.y = Path4.y - 8
    Path5.y = Path5.y - 8
    Path6.y = Path6.y - 8
    Path7.y = Path7.y - 8
    Path8.y = Path8.y - 8
    Path9.y = Path9.y - 8
    Path10.y = Path10.y - 8
    redZone.y = redZone.y - 8
    redZone1.y = redZone1.y - 8
    redZone2.y = redZone2.y - 8
    redZone3.y = redZone3.y - 8
    redZone4.y = redZone4.y - 8
    redZone5.y = redZone5.y - 8
    redZone6.y = redZone6.y - 8
    redZone7.y = redZone7.y - 8
    redZone8.y = redZone8.y - 8
    redZone9.y = redZone9.y - 8
    greenZone1.y = greenZone1.y - 8
    GrassyArea.y = GrassyArea.y - 8
    StartingPosition.y = StartingPosition.y - 8
    StartingPosition1.y = StartingPosition1.y - 8
    Objective.y = Objective.y - 8
    greenZone.y = greenZone.y - 8
end

--Function that moves the map
local function moveTilesLeft()
    background.x = background.x - 8
    Path1.x = Path1.x - 8
    Path2.x = Path2.x - 8
    Path3.x = Path3.x - 8
    Path4.x = Path4.x - 8
    Path5.x = Path5.x - 8
    Path6.x = Path6.x - 8
    Path7.x = Path7.x - 8
    Path8.x = Path8.x - 8
    Path9.x = Path9.x - 8
    Path10.x = Path10.x - 8
    redZone.x = redZone.x - 8
    redZone1.x = redZone1.x - 8
    redZone2.x = redZone2.x - 8
    redZone3.x = redZone3.x - 8
    redZone4.x = redZone4.x - 8
    redZone5.x = redZone5.x - 8
    redZone6.x = redZone6.x - 8
    redZone7.x = redZone7.x - 8
    redZone8.x = redZone8.x - 8
    redZone9.x = redZone9.x - 8
    greenZone1.x = greenZone1.x - 8
    GrassyArea.x = GrassyArea.x - 8
    StartingPosition.x = StartingPosition.x - 8
    StartingPosition1.x = StartingPosition1.x - 8
    Objective.x = Objective.x - 8
    greenZone.x = greenZone.x - 8
end

--Function that moves the map
local function moveTilesRight()
    background.x = background.x + 8
    Path1.x = Path1.x + 8
    Path2.x = Path2.x + 8
    Path3.x = Path3.x + 8
    Path4.x = Path4.x + 8
    Path5.x = Path5.x + 8
    Path6.x = Path6.x + 8
    Path7.x = Path7.x + 8
    Path8.x = Path8.x + 8
    Path9.x = Path9.x + 8
    Path10.x = Path10.x + 8
    redZone.x = redZone.x + 8
    redZone1.x = redZone1.x + 8
    redZone2.x = redZone2.x + 8
    redZone3.x = redZone3.x + 8
    redZone4.x = redZone4.x + 8
    redZone5.x = redZone5.x + 8
    redZone6.x = redZone6.x + 8
    redZone7.x = redZone7.x + 8
    redZone8.x = redZone8.x + 8
    redZone9.x = redZone9.x - 8
    greenZone1.x = greenZone1.x + 8
    GrassyArea.x = GrassyArea.x + 8
    StartingPosition.x = StartingPosition.x + 8
    StartingPosition1.x = StartingPosition1.x + 8
    Objective.x = Objective.x + 8
    greenZone.x = greenZone.x + 8
end

--dragging function to move doggo into red zone
local function moveTilesUpAgainst()
    background.y = background.y + 2
    Path1.y = Path1.y + 2
    Path2.y = Path2.y + 2
    Path3.y = Path3.y + 2
    Path4.y = Path4.y + 2
    Path5.y = Path5.y + 2
    Path6.y = Path6.y + 2
    Path7.y = Path7.y + 2
    Path8.y = Path8.y + 2
    Path9.y = Path9.y + 2
    Path10.y = Path10.y + 2
    redZone.y = redZone.y + 2
    redZone1.y = redZone1.y + 2
    redZone2.y = redZone2.y + 2
    redZone3.y = redZone3.y + 2
    redZone4.y = redZone4.y + 2
    redZone5.y = redZone5.y + 2
    redZone6.y = redZone6.y + 2
    redZone7.y = redZone7.y + 2
    redZone8.y = redZone8.y + 2
    redZone9.y = redZone9.y + 2
    greenZone.y = greenZone.y + 2
    greenZone1.y = greenZone1.y + 2
    GrassyArea.y = GrassyArea.y + 2
    StartingPosition.y = StartingPosition.y + 2
    StartingPosition1.y = StartingPosition1.y + 2
    Objective.y = Objective.y + 2
end

--dragging function to move doggo into red zone
local function moveTilesDownAgainst()
    background.y = background.y - 2
    Path1.y = Path1.y - 2
    Path2.y = Path2.y - 2
    Path3.y = Path3.y - 2
    Path4.y = Path4.y - 2
    Path5.y = Path5.y - 2
    Path6.y = Path6.y - 2
    Path7.y = Path7.y - 2
    Path8.y = Path8.y - 2
    Path9.y = Path9.y - 2
    Path10.y = Path10.y - 2
    redZone.y = redZone.y - 2
    redZone1.y = redZone1.y - 2
    redZone2.y = redZone2.y - 2
    redZone3.y = redZone3.y - 2
    redZone4.y = redZone4.y - 2
    redZone5.y = redZone5.y - 2
    redZone6.y = redZone6.y - 2
    redZone7.y = redZone7.y - 2
    redZone8.y = redZone8.y - 2
    redZone9.y = redZone9.y - 2
    greenZone.y = greenZone.y - 2
    greenZone1.y = greenZone1.y - 2
    GrassyArea.y = GrassyArea.y - 2
    StartingPosition.y = StartingPosition.y - 2
    StartingPosition1.y = StartingPosition1.y - 2
    Objective.y = Objective.y - 2
end

--dragging function to move doggo into red zone
local function moveTilesLeftAgainst()
    background.x = background.x - 2
    Path1.x = Path1.x - 2
    Path2.x = Path2.x - 2
    Path3.x = Path3.x - 2
    Path4.x = Path4.x - 2
    Path5.x = Path5.x - 2
    Path6.x = Path6.x - 2
    Path7.x = Path7.x - 2
    Path8.x = Path8.x - 2
    Path9.x = Path9.x - 2
    Path10.x = Path10.x - 2
    redZone.x = redZone.x - 2
    redZone1.x = redZone1.x - 2
    redZone2.x = redZone2.x - 2
    redZone3.x = redZone3.x - 2
    redZone4.x = redZone4.x - 2
    redZone5.x = redZone5.x - 2
    redZone6.x = redZone6.x - 2
    redZone7.x = redZone7.x - 2
    redZone8.x = redZone8.x - 2
    redZone9.x = redZone9.x - 2
    greenZone.x = greenZone.x - 2
    greenZone1.x = greenZone1.x - 2
    GrassyArea.x = GrassyArea.x - 2
    StartingPosition.x = StartingPosition.x - 2
    StartingPosition1.x = StartingPosition1.x - 2
    Objective.x = Objective.x - 2
end

--dragging function to move doggo into red zone
local function moveTilesRightAgainst()
    background.x = background.x + 2
    Path1.x = Path1.x + 2
    Path2.x = Path2.x + 2
    Path3.x = Path3.x + 2
    Path4.x = Path4.x + 2
    Path5.x = Path5.x + 2
    Path6.x = Path6.x + 2
    Path7.x = Path7.x + 2
    Path8.x = Path8.x + 2
    Path9.x = Path9.x + 2
    Path10.x = Path10.x + 2
    redZone.x = redZone.x + 2
    redZone1.x = redZone1.x + 2
    redZone2.x = redZone2.x + 2
    redZone3.x = redZone3.x + 2
    redZone4.x = redZone4.x + 2
    redZone5.x = redZone5.x + 2
    redZone6.x = redZone6.x + 2
    redZone7.x = redZone7.x + 2
    redZone8.x = redZone8.x + 2
    redZone9.x = redZone9.x + 2
    greenZone.x = greenZone.x + 2
    greenZone1.x = greenZone1.x + 2
    GrassyArea.x = GrassyArea.x + 2
    StartingPosition.x = StartingPosition.x + 2
    StartingPosition1.x = StartingPosition1.x + 2
    Objective.x = Objective.x + 2
end

--function that checks if the dog is touching the red zone
local function onGreenZoneCollision(obj1, obj2)
if (Start == "done") then
    local con1 = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local con2 = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local con3 = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local con4 = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

    if ((con1 and con2) or (con1 and con4) or (con2 and con3) or (con4 and con2)) then
        return true
    end
end
end

local function onRedZoneCollision( obj1, obj2 )
if (Start == "done") then
    local con1 = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local con2 = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local con3 = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local con4 = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

    if ((con1 and con3) or (con1 and con4) or (con2 and con4) or (con2 and con3)) then
        return true
    end
end
end

--function which checks to see if the dog touches the objective
local function onObjectiveCollision( obj1, obj2 )

    local con1 = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local con2 = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local con3 = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local con4 = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

    if ((con1 and con3) or (con1 and con4) or (con2 and con4) or (con2 and con3)) then
        return true
    end
end

--Function that checks if the dog is touching the path
local function onPathCollision( obj1, obj2 )
if (Start == "done") then
    local con1 = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local con2 = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local con3 = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local con4 = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

    if ((con1 and con2) or (con1 and con4) or (con2 and con3) or (con4 and con2) or (con3 and con4) or (con1 and con2)) then
        return true
    end
end
end

local function endGame()
    composer.gotoScene("Level3.GameOver3", { time = 500, effect = "crossFade"})
end

local function gameLoopSecond( event )
   time = time - 1
   if(time <= 0) then
      endGame()
   end
end

local function start()
    if (Start == "begin") then
        disableControls = "Enabled"
        time = 300
        Path1.isVisible = false
        Path2.isVisible = false
        Path3.isVisible = false
        Path4.isVisible = false
        Path5.isVisible = false
        Path6.isVisible = false
        Path7.isVisible = false
        Path8.isVisible = false
        Path9.isVisible = false
        Path10.isVisible = false
        redZone.isVisible = false
        redZone1.isVisible = false
        redZone2.isVisible = false
        redZone3.isVisible = false
        redZone4.isVisible = false
        redZone5.isVisible = false
        redZone6.isVisible = false
        redZone7.isVisible = false
        redZone8.isVisible = false
        redZone9.isVisible = false
        greenZone.isVisible = false
        greenZone1.isVisible = false
        GrassyArea.isVisible = false
        StartingPosition.isVisible = true
        if (onObjectiveCollision(Doggo, StartingPosition)) then
            Start = "done"
            disableControls = "Disabled"
        else
            moveTilesRight()
            moveTilesDown()
        end
    elseif (onPathCollision(Doggo, StartingPosition)) then
        Path1.isVisible = true
        Path2.isVisible = true
        Path3.isVisible = true
        Path4.isVisible = true
        Path5.isVisible = true
        Path6.isVisible = true
        Path7.isVisible = true
        Path8.isVisible = true
        Path9.isVisible = true
        Path10.isVisible = true
        redZone.isVisible = true
        redZone1.isVisible = true
        redZone2.isVisible = true
        redZone3.isVisible = true
        redZone4.isVisible = true
        redZone5.isVisible = true
        redZone6.isVisible = true
        redZone7.isVisible = true
        redZone8.isVisible = true
        redZone9.isVisible = true
        greenZone.isVisible = true
        greenZone1.isVisible = true
        GrassyArea.isVisible = true
        StartingPosition.isVisible = false
    end
end

local function moveToStart()
if (moveStart == 0) then
    disableControls = "Enabled"
    Startx = 1950
    Starty = -1000
    Currentx = background.x
    Currenty = background.y
    while Startx > Currentx do
        Currentx = background.x
        moveTilesRight()
    end
    while Starty < Currenty do
        Currenty = background.y
        moveTilesDown()
    end
    disableControls = "Disabled"
end
end

--function that checks all game variables
local function gameLoop( event )
    start()

    if (onObjectiveCollision( Doggo, Objective) == true) then
        nextLevel()
    end

    timeText.text = "Time left: " .. time

    if onGreenZoneCollision( Doggo, greenZone) then
        time = time - 3
    end

    if onRedZoneCollision( Doggo, redZone) then
        time = time - 2
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone1) then
        time = time - 2
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone2) then
        time = time - 2
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone3) then
        time = time - 2
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone4) then
        time = time - 2
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone5) then
        time = time - 2
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone6) then
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone7) then
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone8) then
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onRedZoneCollision( Doggo, redZone9) then
        hideScents()
        moveStart = 0
        moveToStart()
    end

    if onGreenZoneCollision( Doggo, greenZone1) then
        time = time - 2
    end

    if onPathCollision( Doggo, Path1 ) then
        Path1.isVisible = true
    elseif onPathCollision( Doggo, Path3) then
        Path3.isVisible = true
    elseif onPathCollision( Doggo, Path2) then
        Path2.isVisible = true
    elseif onPathCollision( Doggo, Path4) then
        Path4.isVisible = true
    elseif onPathCollision( Doggo, Path5) then
        Path5.isVisible = true
    elseif onPathCollision( Doggo, Path6) then
        Path6.isVisible = true
    elseif onPathCollision( Doggo, Path7) then
        Path7.isVisible = true
    elseif onPathCollision( Doggo, Path8) then
        Path8.isVisible = true
    elseif onPathCollision( Doggo, Path9) then
        Path9.isVisible = true
    elseif onPathCollision( Doggo, Path10) then
        Path10.isVisible = true
    else
        Path1.isVisible = false
        Path2.isVisible = false
        Path3.isVisible = false
        Path4.isVisible = false
        Path5.isVisible = false
        Path6.isVisible = false
        Path7.isVisible = false
        Path8.isVisible = false
        Path9.isVisible = false
        Path10.isVisible = false
    end

    return true
end

--movement controls
local function movementKeys( event )
if(disableControls == "Disabled") then
  if ((event.keyName == 'd' or event.keyName == 'right') and event.phase == 'down' ) then
    d = 'down'
    right = 'down'
  else
    d = 'up'
    right = 'up'
  end
  if ((event.keyName == 'a' or event.keyName == 'left') and event.phase == 'down' ) then
    a = 'down'
    left = 'down'
  else
    a = 'up'
    left = 'up'
  end
  if ((event.keyName == 'down' or event.keyName == 's') and event.phase == 'down' ) then
    down = 'down'
  else
    down = 'up'
  end
  if ((event.keyName == 'up' or event.keyName == 'w') and event.phase == 'down' ) then
    up = 'down'
  else
    up = 'up'
  end
  if (event.keyName == 'space' and event.phase == 'down') then
    space = 'down'
else
    space = 'up'
end
else
    d = 'up'
    a = 'up'
    s = 'up'
    w = 'up'
    up = 'up'
    down = 'up'
    space = 'up'
    right = 'up'
    left = 'up'
end
end

--Basic Doggo movement
local function walkPerson( event )
  if (d == 'down' or right == 'down') then
    Doggo.rotation = 180

    if (background.x >= -310 and Doggo.x >= 640) then
        moveTilesLeft()
    else
        Doggo.x = Doggo.x + 10
    end

  elseif (a == 'down' or left == 'down') then
    Doggo.rotation = 0

    if (background.x <= 1550 and Doggo.x <= 640) then
        moveTilesRight()
    else
        Doggo.x = Doggo.x -10
    end

  elseif (w == 'down' or up == 'down') then
Doggo.rotation = 90

    if (background.y <= 1550 and Doggo.y <= 360) then
        moveTilesUp()
    else
        Doggo.y = Doggo.y -10
    end

  elseif (s == 'down' or down == 'down') then
  	 Doggo.rotation = -90
    if (background.y >= -850 and Doggo.y >= 360) then
        moveTilesDown()
    else
        Doggo.y = Doggo.y + 10
    end
        elseif(space == 'down') then
        print("background.x = " .. background.x)
        print("background.y = " .. background.y)
        print("Doggo.x = " .. redZone5.x)
        print("Doggo.y = " .. redZone5.y)
    end
end

--when player is on path this will drag the player to the red
local function pathDrag( event )
if(disableControls == "Disabled") then
  if (onPathCollision( Doggo, Path2) or onPathCollision( Doggo, Path7) or onPathCollision(Doggo, Path10)) then
    d1 = 'down'
    right1 = 'down'
  else
    d1 = 'up'
    right1 = 'up'
  end
  if (onPathCollision( Doggo, Path5) or onPathCollision(Doggo, Path4)) then
    a1 = 'down'
    left1 = 'down'
  else
    a1 = 'up'
    left1 = 'up'
  end
  if (onPathCollision( Doggo, Path9) or onPathCollision(Doggo, Path6)) then
    down1 = 'down'
  else
    down1 = 'up'
  end
  if (onPathCollision( Doggo, Path3) or onPathCollision( Doggo, Path8)) then
    up1 = 'down'
  else
    up1 = 'up'
  end
end
end

--This is the function that drags the dog
local function dragDoggo( event )

  if (d1 == 'down' or right1 == 'down') then
    if (background.x >= -310 and Doggo.x >= 640) then
        moveTilesLeftAgainst()
    else
        Doggo.x = Doggo.x + 1
    end

  elseif (a1 == 'down' or left1 == 'down') then

    if (background.x <= 1550 and Doggo.x <= 640) then
        moveTilesRightAgainst()
    elseif (background.x >= 1550 or background.x <= -310) then
        Doggo.x = Doggo.x - 1
    elseif(Doggo.x > 640 and background.x > -310) then
        moveTilesRightAgainst()
    else
        Doggo.x = Doggo.x - 1
    end

  elseif (w1 == 'down' or up1 == 'down') then

    if (background.y <= 1550 and Doggo.y <= 360) then
        moveTilesUpAgainst()
    else
        Doggo.y = Doggo.y - 1
    end

  elseif (s1 == 'down' or down1 == 'down') then
    if (background.y >= -850 and Doggo.y >= 360) then
        moveTilesDownAgainst()
    else
        Doggo.y = Doggo.y + 1
    end
end
end

-- --------------------------------------------------doggo---------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

local sceneGroup = self.view
-- Code here runs when the scene is first created but has not yet appeared on screen
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        physics.pause()
        Start = "begin"
        StartingPosition = display.newImageRect("Level3/Path1.png", 200, 200)
        StartingPosition.x = display.contentCenterX-1400
        StartingPosition.y = display.contentCenterY+1400
        sceneGroup:insert(StartingPosition)

        StartingPosition1 = display.newImageRect("Level3/Path1.png", 400,850)
        StartingPosition1.x = display.contentCenterX-1200
        StartingPosition1.y = display.contentCenterY+1300
        StartingPosition1.alpha = 0
        sceneGroup:insert(StartingPosition1)

        background = display.newImageRect("Level3/Level3Background.png", 3200, 3200)
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        sceneGroup:insert(background)

        GrassyArea = display.newImageRect("Level3/GrassyArea.png", 2960, 2960)
        GrassyArea.x = display.contentCenterX
        GrassyArea.y = display.contentCenterY
        sceneGroup:insert(GrassyArea)

        --position set
        Path1 = display.newImageRect("Level3/Path1.png", 800, 200)
        Path1.x = display.contentCenterX-1080
        Path1.y = display.contentCenterY+1380
        Path1.alpha = 0.3
        sceneGroup:insert(Path1)

        --position set
        Path2 = display.newImageRect("Level3/Path2.png", 200, 1500)
        Path2.x = display.contentCenterX-580
        Path2.y = display.contentCenterY+720
        Path2.alpha = 0.3
        sceneGroup:insert(Path2)

        --position set
        Path3 = display.newImageRect("Level3/Path3.png", 1800, 200)
        Path3.x = display.contentCenterX-500
        Path3.y = display.contentCenterY-920
        Path3.alpha = 0.3
        sceneGroup:insert(Path3)

        --position set
        Path4 = display.newImageRect("Level3/Path4.png", 200, 1000)
        Path4.x = display.contentCenterX+300
        Path4.y = display.contentCenterY-320
        Path4.alpha = 0.3
        sceneGroup:insert(Path4)

        --position set
        Path5 = display.newImageRect("Level3/Path5.png", 200, 1000)
        Path5.x = display.contentCenterX+1300
        Path5.y = display.contentCenterY-320
        Path5.alpha = 0.3
        sceneGroup:insert(Path5)

        --position set
        Path6 = display.newImageRect("Level3/Path3.png", 800, 200)
        Path6.x = display.contentCenterX+800
        Path6.y = display.contentCenterY+70
        Path6.alpha = 0.3
        sceneGroup:insert(Path6)

        --position set
        Path7 = display.newImageRect("Level3/Path4.png", 200, 1100)
        Path7.x = display.contentCenterX+650
        Path7.y = display.contentCenterY+720
        Path7.alpha = 0.3
        sceneGroup:insert(Path7)

        --position set
        Path8 = display.newImageRect("Level3/Path5.png", 1600, 200)
        Path8.x = display.contentCenterX+700
        Path8.y = display.contentCenterY+1370
        Path8.alpha = 0.3
        sceneGroup:insert(Path8)

        --position set
        Path9 = display.newImageRect("Level3/Path5.png", 800, 200)
        Path9.x = display.contentCenterX-1080
        Path9.y = display.contentCenterY+50
        Path9.alpha = 0.3
        sceneGroup:insert(Path9)


        Path10 = display.newImageRect("Level3/Path5.png", 200, 800)
        Path10.x = display.contentCenterX-1380
        Path10.y = display.contentCenterY-450
        Path10.alpha = 0.3
        sceneGroup:insert(Path10)

        --position set
        redZone = display.newImageRect("Level3/redZone.png", 750, 1000)
        redZone.x = display.contentCenterX-1100
        redZone.y = display.contentCenterY+665
        redZone.alpha = 0.2
        sceneGroup:insert(redZone)

        --position set
        redZone1 = display.newImageRect("Level3/redZone.png", 700, 1000)
        redZone1.x = display.contentCenterX+800
        redZone1.y = display.contentCenterY-550
        redZone1.alpha = 0.2
        sceneGroup:insert(redZone1)

        --position set
        redZone2 = display.newImageRect("Level3/redZone.png", 650, 1050)
        redZone2.x = display.contentCenterX+1100
        redZone2.y = display.contentCenterY+700
        redZone2.alpha = 0.2
        sceneGroup:insert(redZone2)

        --position set
        redZone3 = display.newImageRect("Level3/redZone.png", 1000, 1000)
        redZone3.x = display.contentCenterX + 25
        redZone3.y = display.contentCenterY+700
        redZone3.alpha = 0.2
        sceneGroup:insert(redZone3)

        --position set
        redZone4 = display.newImageRect("Level3/redZone.png", 350, 250)
        redZone4.x = display.contentCenterX-300
        redZone4.y = display.contentCenterY+1350
        redZone4.alpha = 0.2
        sceneGroup:insert(redZone4)

        --position set
        redZone5 = display.newImageRect("Level3/redZone.png", 850, 700)
        redZone5.x = display.contentCenterX-850
        redZone5.y = display.contentCenterY-420
        redZone5.alpha = 0.2
        sceneGroup:insert(redZone5)

        redZone6 = display.newImageRect("Level3/redZone.png", 50, 3200)
        redZone6.x = display.contentCenterX-1550
        redZone6.y = display.contentCenterY
        redZone6.alpha = 0.2
        sceneGroup:insert(redZone6)

        redZone7 = display.newImageRect("Level3/redZone.png", 3200, 50)
        redZone7.x = display.contentCenterX
        redZone7.y = display.contentCenterY+1550
        redZone7.alpha = 0.2
        sceneGroup:insert(redZone7)

        redZone8 = display.newImageRect("Level3/redZone.png", 50, 3200)
        redZone8.x = display.contentCenterX+1550
        redZone8.y = display.contentCenterY
        redZone8.alpha = 0.2
        sceneGroup:insert(redZone8)

        redZone9 = display.newImageRect("Level3/redZone.png", 3200, 50)
        redZone9.x = display.contentCenterX + 2600
        redZone9.y = display.contentCenterY - 1525
        redZone9.alpha = 0.2
        sceneGroup:insert(redZone9)

        --position set
        greenZone1 = display.newImageRect("Level3/greenZone.png", 2600, 400)
        greenZone1.x = display.contentCenterX-250
        greenZone1.y = display.contentCenterY-1220
        greenZone1.alpha = 0.2
        sceneGroup:insert(greenZone1)

        --position set
        greenZone = display.newImageRect("Level3/greenZone.png", 500, 1000)
        greenZone.x = display.contentCenterX-150
        greenZone.y = display.contentCenterY-300
        greenZone.alpha = 0.2
        sceneGroup:insert(greenZone)

        Objective = display.newImageRect("Level3/cane.png", 200, 200)
        Objective.x = display.contentCenterX+1300
        Objective.y = display.contentCenterY-1300
        sceneGroup:insert(Objective)

        timeText = display.newText("Lives: " .. time, 200, 100, native.systemFont, 36 )
        sceneGroup:insert(timeText)

        Doggo = display.newImageRect("Level3/Doggo.png", 100, 50)
        Doggo.x = display.contentCenterX
        Doggo.y = display.contentCenterY
        Doggo.isFixedRotation = true
        sceneGroup:insert(Doggo)

        physics.addBody( Doggo, "dynamic", {friction = 1.0})

        pauseButton = display.newImageRect("Menus/pauseButton.png", 100, 120)
        pauseButton.x = display.contentCenterX + 500
        pauseButton.y = display.contentCenterY - 265
        sceneGroup:insert(pauseButton)
        pauseButton:addEventListener("tap", pause )
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener( "key", movementKeys )
        Runtime:addEventListener( "enterFrame", walkPerson )
        Runtime:addEventListener( "enterFrame", gameLoop )
        Runtime:addEventListener("collision", onPathCollision)
        terenceTimer = timer.performWithDelay(1000, gameLoopSecond, -1)
        Runtime:addEventListener("enterFrame", dragDoggo)
        Runtime:addEventListener("enterFrame", pathDrag)
        gameOverSound = audio.loadSound("Audio/gameOver1.wav")
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    Runtime:removeEventListener("enterFrame", gameLoop)
    Runtime:removeEventListener("key", movementKeys)
    Runtime:removeEventListener("enterFrame", walkPerson)
    Runtime:removeEventListener("collision" , onPathCollision)
    Runtime:removeEventListener("enterFrame", dragDoggo)
    Runtime:removeEventListener("enterFrame", pathDrag)
    display.remove(timeText)
    disableControls = "Enabled"
    Doggo.isVisible = false
    background.isVisible = false
    hideScents()
    time = 403
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    audio.stop( 1 )
    physics.removeBody(Doggo)
    physics.pause()
    composer.removeScene("Level3\Level3")
    end
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
     timer.cancel( terenceTimer )
    audio.dispose(gameOverSound)
    audio.remove(level3Music)
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "resumeGame", scene )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
