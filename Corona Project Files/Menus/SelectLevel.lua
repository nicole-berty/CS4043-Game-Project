local composer = require ("composer")
local scene = composer.newScene()
local backgroundMusic

local function gotoLevel1()
  composer.gotoScene("Level1.Level1Cutscene", { time=300, effect="fade" } )
end

local function gotoLevel2()
  composer.gotoScene("Level2.Level2Cutscene", { time=300, effect="fade" } )
end

local function gotoLevel3()
  composer.gotoScene("Level3.Level3Cutscene", { time=300, effect="fade" } )
end

local function gotoLevel4()
  composer.gotoScene("Level4.Level4Cutscene", { time=300, effect="fade" } )
end

local function gotoMenu()
  composer.gotoScene("Menus.Menu", { time=300, effect="fade" } )
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

  local quitButton = display.newImageRect("Menus/quitButton.png", 500, 120)
  quitButton.x = display.contentCenterX + 300
  quitButton.y = display.contentCenterY + 200
  screenGroup:insert(quitButton)
  quitButton:addEventListener("tap", closeGame )

  local Level1Button = display.newImageRect("Menus/Level1Button.png", 500, 120)
  Level1Button.x = display.contentCenterX - 300
  Level1Button.y = display.contentCenterY - 200
  screenGroup:insert(Level1Button)
  Level1Button:addEventListener("tap", gotoLevel1 )

  local Level2Button = display.newImageRect("Menus/Level2Button.png", 500, 120)
  Level2Button.x = display.contentCenterX + 300
  Level2Button.y = display.contentCenterY - 200
  screenGroup:insert(Level2Button)
  Level2Button:addEventListener("tap", gotoLevel2 )

  local Level3Button = display.newImageRect("Menus/Level3Button.png", 500, 120)
  Level3Button.x = display.contentCenterX - 300
  Level3Button.y = display.contentCenterY
  screenGroup:insert(Level3Button)
  Level3Button:addEventListener("tap", gotoLevel3 )

  local Level4Button = display.newImageRect("Menus/Level4Button.png", 500, 120)
  Level4Button.x = display.contentCenterX + 300
  Level4Button.y = display.contentCenterY
  screenGroup:insert(Level4Button)
  Level4Button:addEventListener("tap", gotoLevel4 )

  local BackButton = display.newImageRect("Menus/BackButton.png", 500, 120)
  BackButton.x = display.contentCenterX - 300
  BackButton.y = display.contentCenterY + 200
  screenGroup:insert(BackButton)
  BackButton:addEventListener("tap", gotoMenu )

  backgroundMusic = audio.loadStream("Audio/MenuMusic.mp3")

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    audio.play(backgroundMusic, {channel=1, loops = -1})
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
      audio.stop( 1 )
      composer.removeScene("Menus\SelectLevel")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    audio.remove(backgroundMusic)
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
