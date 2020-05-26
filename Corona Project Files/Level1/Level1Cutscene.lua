local composer = require ("composer")
local scene = composer.newScene()

local backgroundMusic1

local function gotoMenu()
  audio.stop( 1 )
  composer.gotoScene("Menus.Menu", { time=300, effect="fade" } )
end

local function gotoLevel1()
  composer.gotoScene("Level1.Level1", { time=300, effect="fade" } )
end

function scene:create(event)

  local screenGroup = self.view

  local background = display.newImageRect("Level1/Background2.jpg", 1280, 720)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  screenGroup:insert(background)

  local Level1Cutscene = display.newImageRect("Level1/Level1Cutscene.png", 800,500)
  Level1Cutscene.x = display.contentCenterX + 200
  Level1Cutscene.y = display.contentCenterY - 100
  screenGroup:insert(Level1Cutscene)

  local rainbowMan = display.newImageRect("Menus/RainbowMan.png", 1200,650)
  rainbowMan.x = display.contentCenterX - 450
  rainbowMan.y = display.contentCenterY - 100
  screenGroup:insert(rainbowMan)

  local BackButton = display.newImageRect("Menus/BackButton.png", 500, 120)
  BackButton.x = display.contentCenterX - 350
  BackButton.y = display.contentCenterY + 250
  screenGroup:insert(BackButton)
  BackButton:addEventListener("tap", gotoMenu )

  local ContinueButton = display.newImageRect("Menus/ContinueButton.png", 500, 120)
  ContinueButton.x = display.contentCenterX + 300
  ContinueButton.y = display.contentCenterY + 250
  screenGroup:insert(ContinueButton)
  ContinueButton:addEventListener("tap", gotoLevel1 )

  backgroundMusic1 = audio.loadStream("Audio/backgroundMusic1.wav")

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
        audio.play(backgroundMusic1, {channel=1, loops = -1})
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
    composer.removeScene("Level1\Level1Cutscene")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
    audio.remove(backgroundMusic1)
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
