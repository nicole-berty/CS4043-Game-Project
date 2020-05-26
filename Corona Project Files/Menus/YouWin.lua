local composer = require ("composer")
local scene = composer.newScene()

local YouWinMusic

local function gotoMenu()
  composer.gotoScene("Menus.Menu", { time=300, effect="fade" } )
end

local function closeGame()
    native.requestExit()
end

function scene:create(event)

    local screenGroup = self.view
    local background = display.newImageRect("Menus/winBackground.jpg", 1280, 720)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    screenGroup:insert(background)

    local rainbowMan = display.newImageRect("Menus/RainbowMan.png", 1100,650)
    rainbowMan.x = display.contentCenterX - 465
    rainbowMan.y = display.contentCenterY - 100
    screenGroup:insert(rainbowMan)

    local playAgain = display.newImageRect("Menus/playAgain.png", 500, 120)
    playAgain.x = display.contentCenterX + 350
    playAgain.y = display.contentCenterY + 300
    screenGroup:insert(playAgain)
    playAgain:addEventListener("tap", gotoMenu )

    local quit = display.newImageRect("Menus/Quit.png", 500, 150)
    quit.x = display.contentCenterX - 375
    quit.y = display.contentCenterY + 300
    screenGroup:insert(quit)
    quit:addEventListener("tap", closeGame )

    local YouWinCutscene = display.newImageRect("Menus/YouWinCutscene.png", 800,500)
    YouWinCutscene.x = display.contentCenterX + 250
    YouWinCutscene.y = display.contentCenterY - 15
    screenGroup:insert(YouWinCutscene)

    local YouWin = display.newImageRect("Menus/YouWin.png", 1000,400)
    YouWin.x = display.contentCenterX + 220
    YouWin.y = display.contentCenterY - 260
    screenGroup:insert(YouWin)

    local gold = display.newImageRect("Menus/gold.png", 200,300)
    gold.x = display.contentCenterX - 190
    gold.y = display.contentCenterY + 205
    screenGroup:insert(gold)

    YouWinMusic = audio.loadStream("Audio/youWin.wav")

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
      audio.play(YouWinMusic, {channel=1, loops = -1})
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
    composer.removeScene("Menus\YouWin")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    audio.remove(YouWinMusic)
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
