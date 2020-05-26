local composer = require( "composer" )
local scene = composer.newScene()

local physics = require( "physics" )
--physics.setDrawMode("hybrid")
physics.start()

local ground, topWall
local tree, tree2, tree3,tree4
local bird, newCoin, newArrow, thisCoin, thisArrow
local bg, bg2, bg3, bg4
local lives = 3
local score = 0
local died = false
local livesText, scoreText
local updateTimer, gameLoopTimer
local scrollSpeed = 2
local coinsTable = {}
local arrowsTable = {}
local kaching, deathSound, gameOverSound
local pauseButton

function scene:resumeGame(event)
    physics.start()
    transition.resume()
    local resumeTime = timer.resume( updateTimer )
    local resumeTime = timer.resume( gameLoopTimer )
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
      Runtime:removeEventListener( "tap", BirdFlight )
      Runtime:removeEventListener( "collision", onCollision )
      local pauseTime = timer.pause( updateTimer )
      local pauseTime = timer.pause( gameLoopTimer )
      livesText.alpha = 0
      scoreText.alpha = 0
      audio.pause(1)
      transition.pause()
      physics.pause()
      composer.showOverlay( "Menus.pauseGame", options )
end

local function endGame()
    composer.gotoScene("Level2.GameOver2", { time = 800, effect = "crossFade"})
end

local function nextLevel()
    composer.gotoScene("Level3.Level3Cutscene", { time = 800, effect = "crossFade"})
end

function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

local function createCoins()
    local sceneGroup = scene.view

    newCoin = display.newImageRect( "Coin.png", 40, 30 )
    physics.addBody( newCoin, "static", { radius = 19 } )
    table.insert( coinsTable, 1, newCoin )
    newCoin.myName = "Coin"

    newCoin.x = display.contentWidth + 60
    newCoin.y = math.random( 700 )
    transition.to(newCoin, {time = 3500, x = -20})
    sceneGroup:insert(newCoin)
end

local function createArrow()
    local sceneGroup = scene.view

    newArrow = display.newImageRect( "Level2/arrow.png", 150, 105 )
    physics.addBody( newArrow, "static", { radius = 17 } )
    table.insert( arrowsTable, 1, newArrow )
    newArrow.myName = "Arrow"

    newArrow.x = display.contentWidth + 60
    newArrow.y = math.random( 500 )
    transition.to(newArrow, {time = 3500, x = -20})
    sceneGroup:insert(newArrow)
end

local function gameLoop()

    -- Create new Arrow
    createArrow()
    createCoins()
  -- Remove Arrows which have drifted off screen
    for i = #arrowsTable, 1, -1 do
      thisArrow = arrowsTable[i]
        if(thisArrow.x ~= nil) then

          if ( thisArrow.x <= 0) then
              display.remove( thisArrow )
              table.remove( arrowsTable, i )
          end
        end
    end
    for i = #coinsTable, 1, -1 do
      thisCoin = coinsTable[i]

        if (thisCoin.x ~= nil) then
          if ( thisCoin.x <= 0) then
              display.remove( thisCoin )
              table.remove( coinsTable, i )
          end
        end
    end
end

local function restoreBird()

    bird.isBodyActive = false
    bird.x = display.contentCenterX
    bird.y = display.contentHeight - 500

    -- Fade in the bird
    transition.to( bird, { alpha=1, time=2000,
    onComplete = function()
    bird.isBodyActive = true
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
      if ( lives <= 0 ) then
          Runtime:removeEventListener( "tap", BirdFlight )
          Runtime:removeEventListener( "collision", onCollision )
          display.remove( scoreText )
          display.remove( livesText )
          audio.play(gameOverSound)
          timer.performWithDelay(800, endGame)
      else
          bird.alpha = 0
          timer.performWithDelay( 500, restoreBird )
      end
  end
end

local function onCollision( event )

      if ( event.phase == "began" ) then

            local obj1 = event.object1
            local obj2 = event.object2

            if (obj1.myName == "bird" and obj2.myName == "Coin" ) then
                audio.play(kaching)
                display.remove(obj2)
                score = score + 200
                updateText()
            end
            if (obj1.myName == "Coin" and obj2.myName == "bird")
            then
                audio.play(kaching)
                score = score + 200
                updateText()
                display.remove(obj1)
              end
            if( score == 1600) then
                Runtime:removeEventListener( "tap", BirdFlight )
                Runtime:removeEventListener( "collision", onCollision )
                display.remove( scoreText )
                display.remove( livesText )
                timer.performWithDelay(100, nextLevel)
            end

            if (obj1.myName == "bird" and obj2.myName == "Arrow" ) then
                display.remove(obj2)
                death()
            end
            if (obj1.myName == "Arrow" and obj2.myName == "bird") then
                display.remove(obj1)
                death()
            end

            if (obj1.myName == "tree" or obj1.myName == "tree2" or obj1.myName == "tree3"
              	or obj1.myName == "tree4" and obj2.myName == "bird" ) or
                (obj2.myName == "tree" or obj2.myName == "tree2" or
                obj2.myName == "tree3" or obj2.myName == "tree4" and obj1.myName == "bird" ) then
                death()
            end
      end
end

function updateObjects()
--Updates IngameObstacles
    ground.x = ground.x - scrollSpeed
    tree.x = tree.x - scrollSpeed
    tree2.x = tree2.x - scrollSpeed
    tree3.x = tree3.x - scrollSpeed
    tree4.x = tree4.x - scrollSpeed

  if (ground.x < -600) then
    ground.x = 1280
    tree.x = 1400
  end
end

function updateBackgrounds()
--far background movement
    bg.x = bg.x - (scrollSpeed -1)
    bg2.x = bg2.x - (scrollSpeed-1)
    bg3.x = bg3.x - (scrollSpeed-1)
    bg4.x = bg4.x - (scrollSpeed-1)

    if (bg.x <= -1280) then
      bg.x = 2560
    end
    if (bg2.x <= -1280) then
      bg2.x = 2560
    end
    if (bg3.x <= -1280) then
      bg3.x = 2560
    end
    if (bg4.x <= -1280) then
      bg4.x = 2560
    end
end

function update( event )
    updateObjects()
    updateBackgrounds()
end

local function BirdFlight( event )
  bird:setLinearVelocity(0, -400)
  --  bird:applyLinearImpulse(0, -.3)
    if (bird.x >= display.contentWidth or bird.x <= 0) then
       death()
    end
end

-- create()
function scene:create( event )

    local sceneGroup = self.view

end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        physics.pause()

        topWall = display.newRect( 500, -2, 2000, 5 )
        sceneGroup:insert(topWall)
        physics.addBody(topWall, "static", {bounce = 0.1})

        bg = display.newImageRect("Level2/Level2BG.jpg", 1280, 720)
        bg.x = display.contentWidth * 0.5; bg.y = display.contentHeight / 2
        sceneGroup:insert(bg)

        bg2 = display.newImageRect("Level2/Level2BG.jpg", 1280, 720)
        bg2.x = bg.x + 1280; bg2.y = display.contentHeight / 2
        sceneGroup:insert(bg2)

        bg3 = display.newImageRect("Level2/Level2BG.jpg", 1280, 720)
        bg3.x = bg2.x + 1280; bg3.y = display.contentHeight / 2
        sceneGroup:insert(bg3)

        bg4 = display.newImageRect("Level2/Level2BG.jpg", 1280, 720)
        bg4.x = bg3.x + 1280; bg4.y = display.contentHeight / 2
        sceneGroup:insert(bg4)

        ground = display.newImageRect("Level2/Level2BackGround.png", 3840, 70)
        ground.y = display.contentCenterY+360;
        ground.x = display.contentCenterX+1280;
        sceneGroup:insert(ground)

        tree = display.newImageRect("Level2/GameTree.png", 216, 324)
        tree.x = display.contentCenterX-250
        tree.y = display.contentCenterY+164
        sceneGroup:insert(tree)
        tree.myName = "tree"

        tree2 = display.newImageRect("Level2/GameTree.png", 216, 324)
        tree2.x = display.contentCenterX+400
        tree2.y = display.contentCenterY+164
        sceneGroup:insert(tree2)
        tree2.myName = "tree2"

        tree3 = display.newImageRect("Level2/GameTree.png", 216, 324)
        tree3.x = display.contentCenterX+1000
        tree3.y = display.contentCenterY+164
        sceneGroup:insert(tree3)
        tree3.myName = "tree3"

        tree4 = display.newImageRect("Level2/GameTree.png", 216, 324)
        tree4.x = display.contentCenterX+1500
        tree4.y = display.contentCenterY+164
        sceneGroup:insert(tree4)
        tree4.myName = "tree4"

        bird = display.newImageRect("Level2/GameBird.png", 70, 75 )
        bird.x = display.contentCenterX
        bird.y = display.contentCenterY - 200
        sceneGroup:insert(bird)
        bird.myName = "bird"

        pauseButton = display.newImageRect("Menus/pauseButton.png", 100, 120)
        pauseButton.x = display.contentCenterX + 500
        pauseButton.y = display.contentCenterY - 265
        sceneGroup:insert(pauseButton)
        pauseButton:addEventListener("tap", pause )

        -- Display lives and score
        livesText = display.newText("Lives: " .. lives, 800, 100, native.systemFont, 36 )
        scoreText = display.newText("Score: " .. score, 1000, 100, native.systemFont, 36 )
        livesText:setFillColor( 1, 0, 0 )
        scoreText:setFillColor( 1, 0, 0 )
        sceneGroup:insert(livesText)
        sceneGroup:insert(scoreText)

        physics.addBody(ground, "static")
        physics.addBody(tree, "static")
        physics.addBody(tree2, "static")
        physics.addBody(tree3, "static")
        physics.addBody(tree4, "static")
        physics.addBody(bird, "dynamic", {friction = 1.0})
        bird.isFixedRotation = true

    elseif ( phase == "did" ) then
        physics.start()
        Runtime:addEventListener("tap", BirdFlight)
        Runtime:addEventListener("collision", onCollision)
        gameLoopTimer = timer.performWithDelay( 1500, gameLoop, 0 )
        updateTimer = timer.performWithDelay(1, update, 0)
        kaching = audio.loadSound("Audio/kaching.wav")
        deathSound = audio.loadSound("Audio/death.wav")
        gameOverSound = audio.loadSound("Audio/gameOver1.wav")
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( updateTimer )
        timer.cancel( gameLoopTimer )
        physics.pause()
        Runtime:removeEventListener( "tap", BirdFlight )
        Runtime:removeEventListener( "collision", onCollision )
        display.remove(livesText)
        display.remove(scoreText)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        lives = 3
        score = 0
        died = false
        audio.stop( 1 )
        physics.removeBody(bird)
        if (newCoin.isBodyActive) then
          physics.removeBody(newCoin)
        end
        if (newArrow.isBodyActive) then
          physics.removeBody(newArrow)
        end
        physics.removeBody(ground)
        physics.removeBody(topWall)
        physics.removeBody(tree)
        physics.removeBody(tree2)
        physics.removeBody(tree3)
        physics.removeBody(tree4)
        for i = #coinsTable, 1, -1 do
          if coinsTable[i].isBodyActive then
            physics.removeBody(coinsTable[i])
          end
            display.remove(coinsTable,i)
            table.remove(coinsTable, i)
        end
        for i = #arrowsTable, 1, -1 do
          if arrowsTable[i].isBodyActive then
            physics.removeBody(arrowsTable[i])
          end
            display.remove(arrowsTable,i)
            table.remove(arrowsTable, i)
        end
        transition.cancel()
        composer.removeScene("Level2\Level2")
      end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
      audio.dispose(kaching)
      audio.dispose(deathSound)
      audio.dispose(gameOverSound)
      audio.remove(backgroundMusic2)
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
--scene:addEventListener( "resumeGame", scene )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
