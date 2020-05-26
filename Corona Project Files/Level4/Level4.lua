local composer = require ("composer")
local scene = composer.newScene()

local physics = require( "physics" )
-- physics.setDrawMode("hybrid")
physics.start()
physics.setGravity(0,50)

local bg1, platform2, platform3, platform, ladder, Sprite, Barrel, platform4
local background, rightWall, platform5, platform6
local gameLoopTimer1, gameLoopTimer2, newCoin, thisCoin, thisBarrel
local lives = 3
local score = 0
local barrelTable = {}
local coinsTable = {}
local livesText, scoreText
local died = false
local newBarrel, topWall
local kaching, deathSound, gameOverSound
local pauseButton
local winCan
local start = 0

function scene:resumeGame(event)

  physics.start()
  timer.resume( gameLoopTimer1 )
  timer.resume( gameLoopTimer2 )
  livesText.alpha = 1
  scoreText.alpha = 1
  audio.resume(1)

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
    timer.pause( gameLoopTimer1 )
    timer.pause( gameLoopTimer2 )
    livesText.alpha = 0
    scoreText.alpha = 0
    physics.pause()
    audio.pause(1)
    composer.showOverlay( "Menus.pauseGame", options )
end

local function endGame()
    composer.gotoScene("Level4.GameOver4", { time =800, effect = "crossFade"})
end

local function youWin()
  composer.gotoScene("Menus.YouWin", { time = 800, effect = "crossFade"})
end

local function updateText()
  livesText.text = "Lives: " .. lives
  scoreText.text = "Score: " .. score
end

local function restoreSprite()

    Sprite.isBodyActive = false
    Sprite.x = display.contentCenterX - 500
    Sprite.y = display.contentCenterY - 100

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

local function moveBackground()
    if(score < 1600) then
      background.y = background.y - 720
      start = 0
    elseif(score>=1600)then
      youWin()
    end
end

local function jump(Sprite)
    Sprite:setLinearVelocity(0, -700)
end

local function walkLeft(Sprite)
    Sprite:setLinearVelocity(-500, 0)
    if(Sprite.y < 150) and (Sprite.x<60) then
        moveBackground()
    end
    Sprite.xScale = -1
end

local function walkRight(Sprite)
    Sprite:setLinearVelocity(500, 0)
    Sprite.xScale = 1
end

local function spriteBoundary(event)
  if (Sprite.x < 0) then
    Sprite.x = 0
  elseif (Sprite.y >720) then
    Sprite.y = 700
  end
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
    physics.addBody( newCoin, "dynamic", { radius = 19 } )
    table.insert( coinsTable, 1, newCoin )
    newCoin.myName = "Coin"

    newCoin.x = 170
    newCoin.y = 90
    sceneGroup:insert(newCoin)
end

local function createBarrel()
    local sceneGroup = scene.view
    newBarrel = display.newImage("Level4/beerTop.png",170,90)
    table.insert( barrelTable, 1, newBarrel )
    physics.addBody( newBarrel, "dynamic", { {friction = 0.063 , bounce = 0} } )
    newBarrel.myName = "Barrel"

    newBarrel.x = 170
    newBarrel.y = 90
    sceneGroup:insert(newBarrel)
end

local function gameLoop1()
    createBarrel()

  for i = #barrelTable, 1, -1 do
  thisBarrel = barrelTable[i]
    if(thisBarrel.x ~= nil) then

      if ( thisBarrel.x <= 0) then

        display.remove( thisBarrel )
        table.remove( barrelTable, i )
      end
    end
  end
end

local function gameLoop2()

    createCoins()

    for i = #coinsTable, 1, -1 do
      thisCoin = coinsTable[i]
      if(thisCoin.x ~= nil) then
        if ( thisCoin.x <= 0) then
            display.remove( thisCoin )
            table.remove( coinsTable, i )
        end
      end
    end
end

local function onCollision( event )

    if ( event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2

        if (obj1.myName == "Sprite" and obj2.myName == "Barrel" ) or
        (obj1.myName == "Barrel" and obj2.myName == "Sprite" ) then
            death()
        end

        if (obj1.myName == "Sprite" and obj2.myName == "Coin" ) then
                    audio.play(kaching)
                    display.remove(obj2)
                    score = score + 200
                    updateText()
                end
                if (obj1.myName == "Coin" and obj2.myName == "Sprite") then
                    audio.play(kaching)
                    score = score + 200
                    updateText()
                    display.remove(obj1)
                end

                if(obj1.myName == "Sprite" and obj2.myName == "winCan") or
                (obj1.myName == "winCan" and obj2.myName == "Sprite") then
                    moveBackground()
                    moveToStart = 0
              end
      end
end



local function moveToStart(event )
    if(start == 0) then
      Sprite.x =60
      Sprite.y =650
      start = 1
    end
end

function scene:create(event)
    local sceneGroup = self.view
end

-- show()
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase

    if (phase == "will") then
      physics.pause()

      background = display.newImageRect("Menus/Background.png",1280,720)
      background.x = display.contentCenterX
      background.y = display.contentCenterY
      sceneGroup:insert(background)

      bg1 = display.newImageRect("Level4/level4Background.png",1280,720)
      bg1.x = display.contentCenterX
      bg1.y = display.contentCenterY
      sceneGroup:insert(bg1)

      bg2 = display.newImageRect("Level4/level4Background.png",1280,720)
      bg2.x = display.contentCenterX
      bg2.y = bg1.y -720
      sceneGroup:insert(bg2)

      platform2 = display.newImageRect("Level4/Platform4.png",1100, 20 )
      platform2.x = display.contentCenterX -170
      platform2.y = display.contentCenterY+250
      platform2.rotation = -17
      sceneGroup:insert(platform2)

      platform6 = display.newImageRect("Level4/Platform4.png",330, 20 )
      platform6.x = display.contentCenterX +510
      platform6.y = display.contentCenterY + 76
      platform6.rotation = -5
      sceneGroup:insert(platform6)

      topWall = display.newRect( 500, -2, 2000, 5 )
      physics.addBody(topWall, "static", {bounce = 0.1})
      sceneGroup:insert(topWall)

      platform5 = display.newImageRect("Level4/Platform4.png",120, 20 )
      platform5.x = 50
      platform5.y = 220
      sceneGroup:insert(platform5)

      platform3 = display.newImageRect("Level4/Platform4.png",700, 20 )
      platform3.x = display.contentCenterX-200
      platform3.y = display.contentCenterY - 90
      platform3.rotation = 8.5
      sceneGroup:insert(platform3)

      platform = display.newImageRect("Level4/Platform4.png",1500, 30 )
      platform.x = display.contentCenterX
      platform.y = display.contentHeight
      sceneGroup:insert(platform)

      winCan = display.newImageRect("Level4/winCan.png",90,140)
      winCan.x = 50
      winCan.y = 120
      sceneGroup:insert(winCan)
      rightWall = display.newRect(1281, 720, 1, 900)
      physics.addBody(rightWall,"static")
      sceneGroup:insert(rightWall)

      platform.myName ="Ground"
      platform2.myName="Ground2"
      platform3.myName="Ground3"

      Sprite = display.newImageRect ("Level4/gameMouse.png", 100,60)
      Sprite.x = display.contentCenterX-500
      Sprite.y = display.contentCenterY+200
      sceneGroup:insert(Sprite)

      physics.addBody( platform,"static" )
      physics.addBody( platform2,"static" )
      physics.addBody( platform3,"static" )
      physics.addBody( Sprite,"dynamic", {friction = 0.1, bounce =0.0 } )
      physics.addBody(platform5,"static")
      physics.addBody(platform6,"static")
      physics.addBody(winCan,"static")

      Sprite.isFixedRotation = true

      Sprite.myName = "Sprite"
      winCan.myName = "winCan"

      pauseButton = display.newImageRect("Menus/pauseButton.png", 100, 120)
      pauseButton.x = display.contentCenterX + 500
      pauseButton.y = display.contentCenterY - 265
      sceneGroup:insert(pauseButton)
      pauseButton:addEventListener("tap", pause )

      livesText = display.newText("Lives: " .. lives, 200, 100, native.systemFont,36 )
      scoreText = display.newText("Score: " .. score, 400, 100, native.systemFont, 36 )
      sceneGroup:insert(livesText)
      sceneGroup:insert(scoreText)

    elseif (phase == "did") then

      physics.start()
      transition.blink( winCan, { time= 4000 } )
      gameLoopTimer1 = timer.performWithDelay(3500, gameLoop1, 0)
      gameLoopTimer2 = timer.performWithDelay(2300, gameLoop2, 0)
      Runtime:addEventListener("key", movementKeys )
      Runtime:addEventListener("collision", onCollision )
      Runtime:addEventListener("enterFrame", spriteBoundary )
      Runtime:addEventListener("enterFrame", moveToStart )
      kaching = audio.loadSound("Audio/kaching.wav")
      deathSound = audio.loadSound("Audio/death.wav")
    end
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      timer.cancel(gameLoopTimer1)
      timer.cancel(gameLoopTimer2)
      display.remove(livesText)
      display.remove(scoreText)

    elseif ( phase == "did" ) then
      Runtime:removeEventListener("key", movementKeys )
      Runtime:removeEventListener("collision", onCollision )
      Runtime:removeEventListener("enterFrame", spriteBoundary )
      Runtime:removeEventListener("enterFrame", moveToStart )
      lives = 3
      score = 0
      died = false
      audio.stop( 1 )
      physics.removeBody(Sprite)
      if( newCoin.isBodyActive) then
          physics.removeBody(newCoin)
      end
      if( newBarrel.isBodyActive) then
          physics.removeBody(newBarrel)
      end
      physics.removeBody(rightWall)
      physics.removeBody(topWall)
      physics.removeBody(platform)
      physics.removeBody(platform2)
      physics.removeBody(platform3)
      physics.removeBody(platform5)
      physics.removeBody(platform6)
      physics.removeBody(winCan)
      for i = #coinsTable, 1, -1 do
          if coinsTable[i].isBodyActive then
            physics.removeBody(coinsTable[i])
          end
          display.remove(coinsTable,i)
          table.remove(coinsTable, i)
        end
      for i = #barrelTable, 1, -1 do
          if barrelTable[i].isBodyActive then
            physics.removeBody(barrelTable[i])
          end
          display.remove(barrelTable,i)
          table.remove(barrelTable, i)
      end
      physics.pause()
      transition.cancel()
      composer.removeScene("Level4\Level4")
    end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    audio.dispose(kaching)
    audio.dispose(deathSound)
    audio.dispose(gameOverSound)
    audio.remove(backgroundMusic4)
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
