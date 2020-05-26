local composer = require ("composer")
local scene = composer.newScene()

local backgroundMusic

local function gotoGame()
  audio.stop( 1 )
  composer.gotoScene("Level1.Level1Cutscene", { time=300, effect="fade" } )
end

local function gotoSelectLevel()
  composer.gotoScene("Menus.SelectLevel", { time = 300, effect="fade"})
end

local function closeGame()
    native.requestExit()
end

function scene:create(event)

  local screenGroup = self.view

  local background = display.newImageRect("Menus/FlagPoles.jpg", 1280, 720)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  screenGroup:insert(background)

  local ULMAP = display.newImageRect("Menus/ULMAP.png", 700, 500)
  ULMAP.x = display.contentCenterX - 270
  ULMAP.y = display.contentCenterY + 180
  screenGroup:insert(ULMAP)

  local playButton = display.newImageRect("Menus/playButton.png", 500, 120)
  playButton.x = display.contentCenterX + 270
  playButton.y = display.contentCenterY - 10
  screenGroup:insert(playButton)
  playButton:addEventListener("tap", gotoGame )

  local selectLevelButton = display.newImageRect("Menus/selectLevelButton.png", 500, 120)
  selectLevelButton.x = display.contentCenterX + 270
  selectLevelButton.y = display.contentCenterY + 120
  screenGroup:insert(selectLevelButton)
  selectLevelButton:addEventListener("tap", gotoSelectLevel )

  local quitButton = display.newImageRect("Menus/quitButton.png", 500, 120)
  quitButton.x = display.contentCenterX + 270
  quitButton.y = display.contentCenterY + 250
  screenGroup:insert(quitButton)
  quitButton:addEventListener("tap", closeGame )

  local Lepresean = display.newImageRect("Menus/Lepresean.png", 200, 250)
  Lepresean.x = display.contentCenterX - 330
  Lepresean.y = display.contentCenterY - 110
  screenGroup:insert(Lepresean)

  local Lepresean2 = display.newImageRect("Menus/newLabel.png", 500, 250)
  Lepresean2.x = display.contentCenterX + 280
  Lepresean2.y = display.contentCenterY - 220
  screenGroup:insert(Lepresean2)

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
      composer.removeScene("Menus\Menu")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  if(gotoGame) then
  audio.remove(backgroundMusic)
  end
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
