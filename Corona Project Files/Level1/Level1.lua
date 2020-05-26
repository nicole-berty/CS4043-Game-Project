local composer = require ("composer")
local scene = composer.newScene()

local physics = require( "physics" )
--physics.setDrawMode("hybrid")
physics.start()
physics.setGravity(0, 50)

local lives = 3
local score = 0
local livesText, scoreText
local Sprite, newCoin, newPlatform, thisCoin, thisPlatform
local died = false
local bg1, bg2, bg3, bg4
local gameLoopTimer1, gameLoopTimer2, updateTimer
local platformTable = {}
local coinsTable = {}
local groupsTable = {}
local group, howMany
local platform, platform2, platform3, platform4, topWall
local kaching, deathSound, gameOverSound

local _W = display.contentWidth; -- Get the width of the screen
local _H = display.contentHeight; -- Get the height of the screen
local scrollSpeed = 2; -- Set Scroll Speed of background
local pauseButton

function scene:resumeGame(event)
    physics.start()
    audio.resume(1)
    transition.resume()
    local resumeTime = timer.resume( updateTimer )
    local resumeTime = timer.resume( gameLoopTimer1 )
    local resumeTime = timer.resume( gameLoopTimer2 )
    livesText.alpha = 1
    scoreText.alpha = 1
end

local function pause()
    local options = {
        isModal = true,
        effect = "fade",
        time = 400
    }
    Runtime:removeEventListener( "key", movementKeys )
    Runtime:removeEventListener( "collision", onCollision )
    Runtime:removeEventListener( "enterFrame", spriteBoundary )
    Runtime:removeEventListener( "collision", onEnemyCollision )
    local pauseTime = timer.pause( updateTimer )
    local pauseTime2 = timer.pause( gameLoopTimer1 )
    local pauseTime3 = timer.pause( gameLoopTimer2 )
    livesText.alpha = 0
    scoreText.alpha = 0
    transition.pause()
    physics.pause()
    audio.pause(1)
    composer.showOverlay( "Menus.pauseGame", options )
end

local function endGame()
    composer.gotoScene("Level1.GameOver1", { time = 500, effect = "crossFade"})
end

local function nextLevel()
    composer.gotoScene("Level2.Level2Cutscene", { time = 800, effect = "crossFade"})
end


local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

function updateBackgrounds(event)
--far background movement
      bg1.x = bg1.x - scrollSpeed
      bg2.x = bg2.x - scrollSpeed
      bg3.x = bg3.x - scrollSpeed
      bg4.x = bg4.x - scrollSpeed

      if (bg1.x <= -2000) then
          bg1.x = 1500
      end
      if (bg2.x <= -2000) then
          bg2.x = 1500
      end
      if (bg3.x <= -2000) then
          bg3.x = 1500
      end
      if (bg4.x <= -2000) then
          bg4.x = 1500
      end
end

local function restoreSprite()

    Sprite.isBodyActive = false
    Sprite.x = display.contentCenterX
    Sprite.y = display.contentHeight - 500

    -- Fade in the Sprite
    transition.to( Sprite, { alpha=1, time=2000,
        onComplete = function()
        Sprite.isBodyActive = true
        died = false
        end
    } )
end

local function death()
  if ( died == false ) then
      died = true
      audio.play(deathSound)
      lives = lives - 1
      updateText()
  end
  if ( lives <= 0 ) then
      audio.play(gameOverSound)
      timer.performWithDelay(100, endGame)
  else
      Sprite.alpha = 0
      timer.performWithDelay( 500, restoreSprite)
  end
end

local function jump(Sprite)
    Sprite:setLinearVelocity(0, -1000)
end

local function walkLeft(Sprite)
    Sprite:setLinearVelocity(-500, 0)
    Sprite.xScale = -1
end

local function walkRight(Sprite)
    Sprite:setLinearVelocity(500, 0)
    Sprite.xScale = 1
end

local function spriteBoundary(event)
  if (Sprite.x >= 1280 or Sprite.x <= 0) then
    death()
 end
end

local function movementKeys( event )
    local xv, yv = Sprite:getLinearVelocity()
  	if ((event.keyName == 'd' or event.keyName == 'right') and event.phase == 'down' ) then
        walkRight(Sprite)
    end
  	if ((event.keyName == 'a' or event.keyName == 'left') and event.phase == 'down' ) then
        walkLeft(Sprite)
    end
  	if ((event.keyName == 'space' or event.keyName == 'w' or event.keyName == 'up') and event.phase == 'down' ) then
        jump(Sprite)
    end
end

local function createCoins()
    local sceneGroup = scene.view
    newCoin = display.newImageRect( "Coin.png", 40, 30 )
    table.insert( coinsTable, 1, newCoin )
    physics.addBody( newCoin, "static", { radius = 19 } )
    newCoin.myName = "Coin"

    newCoin.x = display.contentWidth + 60
    newCoin.y = math.random( 500 )
    transition.to(newCoin, {time = 3500, x = -20})
    sceneGroup:insert(newCoin)
end

local function createPlatform()
    local sceneGroup = scene.view
    newPlatform = display.newImageRect( "Level1/Platform.png", 100, 10 )
    table.insert( platformTable, 1, newPlatform )
    physics.addBody( newPlatform, "static" )
    newPlatform.myName = "Platform"
    newPlatform.x = display.contentWidth + 60
    newPlatform.y = math.random( 200, 500 )
    transition.to(newPlatform, {time = 5500, x = -50})
    sceneGroup:insert(newPlatform)
end

local function createPeople()
  local sceneGroup = scene.view
  howMany = math.random(4)

  if(howMany == 1) then
       group = display.newImageRect("Level1/SinglePersonLeft.png", 50, 130)
  elseif(howMany == 2) then
       group = display.newImageRect("Level1/TwoPeopleLeft.png", 130, 150)
  elseif(howMany == 3) then
       group = display.newImageRect("Level1/ThreePeopleLeft.png", 155, 160)
  else
       group = display.newImageRect("Level1/ScooterLeft.png", 70, 120)
  end

  table.insert(groupsTable, 1, group)
  physics.addBody( group, "static")
  group.myName = "group"
  group.x = display.contentWidth + 60
  group.y = display.contentHeight - 70
  transition.to(group, {time = 5000, x = -100})
  sceneGroup:insert(group)
end

local function gameLoop1()

    createPlatform()

    for i = #platformTable, 1, -1 do
        thisPlatform = platformTable[i]

      if(thisPlatform.x ~= nil) then
        if ( thisPlatform.x <= 0) then
            display.remove( thisPlatform )
            table.remove( platformTable, i )
        end
      end
    end
end

local function gameLoop2()

    createCoins()
    createPeople()

    for i = #coinsTable, 1, -1 do
      thisCoin = coinsTable[i]
      if(thisCoin.x ~= nil) then
        if ( thisCoin.x <= 0) then
            display.remove( thisCoin )
            table.remove( coinsTable, i )
        end
      end
    end
    for i = #groupsTable, 1, -1 do
      thisGroup = groupsTable[i]
        if(thisGroup.x ~= nil) then
          if(thisGroup.x <= 0) then
          display.remove(thisGroup)
          table.remove(groupsTable,i)
          end
        end
    end
end

local function onCollision( event )

    if ( event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2

        if (obj1.myName == "sprite" and obj2.myName == "Coin" ) then
            audio.play(kaching)
            display.remove(obj2)
            score = score + 200
            updateText()
        end
        if (obj1.myName == "Coin" and obj2.myName == "sprite") then
            audio.play(kaching)
            score = score + 200
            updateText()
            display.remove(obj1)
        end
        if( score == 1600) then
            timer.performWithDelay(100, nextLevel)
        end
    end
end

local function onEnemyCollision( event )

        if ( event.phase == "began" ) then
            local obj1 = event.object1
            local obj2 = event.object2

            if (obj1.myName == "group" and obj2.myName == "sprite") or
            (obj1.myName == "sprite" and obj2.myName == "group" ) then
                death()
            end
        end
end

function scene:create(event)
    local sceneGroup = self.view
end

function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase

    if (phase == "will") then
      physics.pause()
      topWall = display.newRect( 500, -2, 2000, 5 )
      physics.addBody(topWall, "static", {bounce = 0.1})
      sceneGroup:insert(topWall)

      -- Add First Background
      bg1 = display.newImageRect("Level1/Background1.png", 2500, 1080)
      bg1.x = _W*0.5; bg1.y = _H/2;
      sceneGroup:insert(bg1)

      -- Add Second Background
      bg2 = display.newImageRect("Level1/Background1.png", 2500, 1080)
      bg2.x = bg1.x + 2500; bg2.y =_H/2;
      sceneGroup:insert(bg2)

      -- Add Third Background
      bg3 = display.newImageRect("Level1/Background1.png", 2500, 1080)
      bg3.x = bg2.x + 2500; bg3.y = _H/2;
      sceneGroup:insert(bg3)

      bg4 = display.newImageRect("Level1/Background1.png", 2500, 1080)
      bg4.x = bg3.x + 2500; bg4.y = _H/2;
      sceneGroup:insert(bg4)

      platform = display.newImageRect( "Level1/bottomPlatform.png", 2500, 5 )
      platform.x = display.contentCenterX
      platform.y = display.contentHeight
      physics.addBody( platform, "static" )
      sceneGroup:insert(platform)

      pauseButton = display.newImageRect("Menus/pauseButton.png", 100, 120)
      pauseButton.x = display.contentCenterX + 500
      pauseButton.y = display.contentCenterY - 265
      sceneGroup:insert(pauseButton)
      pauseButton:addEventListener("tap", pause )

      livesText = display.newText("Lives: " .. lives, 200, 100, native.systemFont, 36 )
      livesText:setFillColor( 1, 0, 0 )
      scoreText = display.newText("Score: " .. score, 400, 100, native.systemFont, 36 )
      scoreText:setFillColor( 1, 0, 0 )
      sceneGroup:insert(livesText)
      sceneGroup:insert(scoreText)

      Sprite = display.newImageRect ("Level1/LepreseanSprite1.png", 100, 125)
      Sprite.x = display.contentCenterX-200
      Sprite.y = display.contentHeight-400
      Sprite.myName = "sprite"
      physics.addBody( Sprite, "dynamic", {friction = 1.0, bounce = 0.0 } )
      Sprite.isFixedRotation = true
      sceneGroup:insert(Sprite)

    elseif (phase == "did") then

      physics.start()
      gameLoopTimer1 = timer.performWithDelay( 1000, gameLoop1, 0 )
      gameLoopTimer2 = timer.performWithDelay(1500, gameLoop2, 0)
      updateTimer = timer.performWithDelay(1, updateBackgrounds, 0)
      Runtime:addEventListener( "key", movementKeys )
      Runtime:addEventListener( "collision", onEnemyCollision )
      Runtime:addEventListener( "enterFrame", spriteBoundary )
      Runtime:addEventListener( "collision", onCollision )
      kaching = audio.loadSound("Audio/kaching.wav")
      deathSound = audio.loadSound("Audio/death.wav")
    end
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        timer.cancel( gameLoopTimer1 )
        timer.cancel( gameLoopTimer2 )
        timer.cancel( updateTimer )
        display.remove(livesText)
        display.remove(scoreText)

    elseif ( phase == "did" ) then

        Runtime:removeEventListener( "key", movementKeys )
        Runtime:removeEventListener( "collision", onCollision )
        Runtime:removeEventListener( "enterFrame", spriteBoundary )
        Runtime:removeEventListener( "collision", onEnemyCollision )
        died = false
        score = 0
        lives = 3
        audio.stop( 1 )
        physics.removeBody(Sprite)
        if (newCoin.isBodyActive) then
          physics.removeBody(newCoin)
        end
        if (newPlatform.isBodyActive) then
          physics.removeBody(newPlatform)
        end
        if (group.isBodyActive) then
          physics.removeBody(group)
        end
        physics.removeBody(topWall)
        physics.removeBody(platform)
        for i = #coinsTable, 1, -1 do
          if coinsTable[i].isBodyActive then
            physics.removeBody(coinsTable[i])
          end
          display.remove(coinsTable,i)
          table.remove(coinsTable, i)
        end
        for i = #platformTable, 1, -1 do
          if platformTable[i].isBodyActive then
            physics.removeBody(platformTable[i])
          end
          display.remove(platformTable,i)
          table.remove(platformTable, i)
        end
        for i = #groupsTable, 1, -1 do
          if groupsTable[i].isBodyActive then
            physics.removeBody(groupsTable[i])
          end
          display.remove(groupsTable,i)
          table.remove(groupsTable, i)
        end
        physics.pause()
        transition.cancel()
        composer.removeScene("Level1\Level1")
    end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    audio.dispose(kaching)
    audio.dispose(deathSound)
    audio.dispose(gameOverSound)
    audio.remove(backgroundMusic1)
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
