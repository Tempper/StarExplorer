-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--configuring the physics engine
local physics = require( "physics" )
physics.start()
-- setting the gravity value by default the standard simulate sthe earths gravity
-- gravity is set to zero due to being within space
physics.setGravity( 0, 0 )

-- Seeding random number generator
math.randomseed( os.time() )

--configuring image sheets
--allows to load multiple images and frames from a single larger image
local sheetOptions =
{
  frames = 
  {
    { -- 1) asteroid 1
      x = 0,
      y = 0,
      width = 102,
      height = 85
    },
    { --2) asteroid 2
      x = 0,
      y = 85,
      width = 90,
      height = 83
    },
    { --3) asteroid 3
      x = 0,
      y = 168,
      width = 100,
      height = 97
    },
    { --4) ship
      x = 0,
      y = 265,
      width = 98,
      height = 79
    },

    { --5) laser
      x = 98,
      y = 265,
      width = 14,
      height = 40
    },
  },
}
-- loading image hseet into memory
local objectSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

--initiazlizing variables
-- keeping track of lives and score
local lives = 3
local score = 0
local died = false

local asteroidsTable = {}


local ship
local gameLoopTimer
local livesText
local scoreText

--setting up display groups
local backGroup = display.newGroup() -- display group for background image
local mainGroup = display.newGroup() -- display group for ship, laser asteroids ect
local uiGroup = display.newGroup() -- disaply group for UI objects such as the score

--loading background
local background = display.newImageRect( backGroup, "background.png", 800, 1400 ) -- indicate the group before file image name
background.x = display.contentCenterX
background.y = display.contentCenterY

--configuiring ship
ship =display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody( ship, { radius=30, isSensor=true } ) --sensor objects detct collison with other objects but do not produce a physical response
ship.MyName = "ship"

--Dispalying lives and score
-- joining string and variable with "..."
livesText = display.newText( uiGroup, "Lives:" .. lives, 200, 80, native.systemFont, 36)
scoreText = display.newText( uiGroup, "Score:" .. lives, 400, 80, native.systemFont, 36)

--hiding status bar
display.setStatusBar( display.HiddenStatusBar  )

--function to update lives and score
local function updateText()
  livesText.text = "Lives: " .. lives
  scoreText.text = "Score: " .. score
end

--creating asteroids
local function createAsteroid()

  local newAsteroid =display.newImageRect( mainGroup, objectSheet, 1, 102, 85 )
  table.insert( asteroidsTable, newAsteroid )
  physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8} )
  newAsteroid.MyName = "asteroid" --given a name to make collison detection easier later on

  -- random generating a number between one and three to decide where the asteroid will be coming from
  local whereFrom = math.random( 3 )
  if (whereFrom == 1 ) then
    --from left
    newAsteroid.x = -60
    newAsteroid.y = math.random( 500 )
    newAsteroid:setLinearVelocity( math.random( 40,120 ) , math.random( 20,60 ) )
  elseif (whereFrom == 2) then
    --from top 
      newAsteroid.x = math.random( display.contentWidth )
      newAsteroid.y = -60
      newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40, 120 ) )
  elseif (whereFrom == 3) then 
    --from right
    newAsteroid.x = display.contentWidth + 60
    newAsteroid.y = math.random( 500 )
    newAsteroid:setLinearVelocity( math.random( -120,-40), math.random( 20,60 ) )
  end
  --making asteroids rotate
  newAsteroid:applyTorque( math.random( -6,6 ) )
end