local composer = require ("composer")
local scene = composer.newScene()

local level4Music

local function gotoLevel4()
  composer.gotoScene("Level4.Level4", { time=400, effect="fade" } )
end

local function gotoMenu()
  audio.stop( 1 )
  composer.gotoScene("Menus.Menu", { time=300, effect="fade" } )
end

function scene:create(event)

    local screenGroup = self.view

    local background = display.newImageRect("Level4/StablesBG.jpg", 1280, 720)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    screenGroup:insert(background)

    local Level4Cutscene = display.newImageRect("Level4/Stables.jpg", 500,200)
    Level4Cutscene.x = display.contentCenterX + 300
    Level4Cutscene.y = display.contentCenterY + 115
    screenGroup:insert(Level4Cutscene)

    local Level4Cutscene = display.newImageRect("Level4/Level4Cutscene.png", 800,500)
    Level4Cutscene.x = display.contentCenterX + 200
    Level4Cutscene.y = display.contentCenterY - 110
    screenGroup:insert(Level4Cutscene)

    local rainbowMan = display.newImageRect("Menus/RainbowMan.png", 1200,650)
    rainbowMan.x = display.contentCenterX - 450
    rainbowMan.y = display.contentCenterY - 100
    screenGroup:insert(rainbowMan)

    local ContinueButton = display.newImageRect("Menus/ContinueButton.png", 500, 120)
    ContinueButton.x = display.contentCenterX + 300
    ContinueButton.y = display.contentCenterY + 250
    screenGroup:insert(ContinueButton)
    ContinueButton:addEventListener("tap", gotoLevel4 )

    local BackButton = display.newImageRect("Menus/BackButton.png", 500, 120)
    BackButton.x = display.contentCenterX - 350
    BackButton.y = display.contentCenterY + 250
    screenGroup:insert(BackButton)
    BackButton:addEventListener("tap", gotoMenu )

    level4Music = audio.loadStream("Audio/backgroundMusic4.wav")

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
      audio.play(level4Music, {channel=1, loops = -1})
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
    composer.removeScene("Level4\Level4Cutscene")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
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
