local composer = require( "composer" )
local scene = composer.newScene()

local function resume()
  composer.hideOverlay("fade", 400)
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

  local rainbowMan = display.newImageRect("Menus/RainbowMan.png", 1200,650)
  rainbowMan.x = display.contentCenterX - 450
  rainbowMan.y = display.contentCenterY - 100
  screenGroup:insert(rainbowMan)

  local Paused = display.newImageRect("Menus/Paused.png", 800,500)
  Paused.x = display.contentCenterX + 220
  Paused.y = display.contentCenterY - 100
  screenGroup:insert(Paused)

  local quitButton = display.newImageRect("Menus/quitButton.png", 500, 120)
  quitButton.x = display.contentCenterX - 300
  quitButton.y = display.contentCenterY + 250
  screenGroup:insert(quitButton)
  quitButton:addEventListener("tap", closeGame )

  local ContinueButton = display.newImageRect("Menus/ContinueButton.png", 500, 120)
  ContinueButton.x = display.contentCenterX + 300
  ContinueButton.y = display.contentCenterY + 250
  screenGroup:insert(ContinueButton)
  ContinueButton:addEventListener("tap", resume)

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent

    if ( phase == "will" ) then
      parent:resumeGame()
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene
