local composer = require ("composer")
local scene = composer.newScene()

local gameOverMusic

local function gotoGame()
  composer.gotoScene("Level4.Level4Cutscene")
end

local function closeGame()
    native.requestExit()
end

function scene:create(event)
    local screenGroup = self.view

    local background = display.newImageRect("Menus/Background.png", 1280, 720)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    screenGroup:insert(background)

    local gameOver = display.newImageRect("Menus/gameOver.png", 750, 400)
    gameOver.x = display.contentCenterX
    gameOver.y = display.contentCenterY - 100
    screenGroup:insert(gameOver)

    local playAgain = display.newImageRect("Menus/playAgain.png", 500, 150)
    playAgain.x = display.contentCenterX
    playAgain.y = display.contentCenterY + 80
    screenGroup:insert(playAgain)
    playAgain:addEventListener("tap", gotoGame )

    local quit = display.newImageRect("Menus/Quit.png", 500, 150)
    quit.x = display.contentCenterX
    quit.y = display.contentCenterY + 200
    screenGroup:insert(quit)
    quit:addEventListener("tap", closeGame )

    gameOverMusic = audio.loadStream("Audio/gameOver.wav")
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    audio.play(gameOverMusic, {channel=1, loops = -1})
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
      audio.stop(1)
      composer.removeScene("Level4\GameOver4")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  audio.remove(gameOverMusic)
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
