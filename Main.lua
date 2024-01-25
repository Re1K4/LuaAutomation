--///////////////////////////////////////////////////////////////////////////
--REQUIRE
--///////////////////////////////////////////////////////////////////////////
require('Event')
require('Timer')
require('Control')
require('Logs')

--///////////////////////////////////////////////////////////////////////////
--GLOBAL SETTINGS
--///////////////////////////////////////////////////////////////////////////
DeveY = 1080 -- Y-axis resolution of the device in use
DeveX = 1920 -- X-axis resolution of the device in use
Settings:setScriptDimension(true, DeveX) -- Set the screen resolution of the script
Settings:setCompareDimension(true, DeveX) -- Set the comparison resolution
setImmersiveMode(true) -- Set whether the target game is in fullscreen mode (true: fullscreen)
package.path = package.path..';'..scriptPath()..'?.lua' -- Add the current path to the search path for the require function

--///////////////////////////////////////////////////////////////////////////
--FUNCTIONS
--///////////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////////
--EVENT OBJECT
--Class for comparing pixels on the screen
--INIT : Event.new(tapx,tapy,gcx1,gcy1,gcol1,gcx2,gcy2,gcol2) return object
    --tapx : X-axis coordinate of the tap point
    --tapy : Y-axis coordinate of the tap point
    --gcx1 : X-axis coordinate of the first recognition point
    --gcy1 : Y-axis coordinate of the first recognition point
    --gcol1 : Color of the first recognition point
    --gcx2 : X-axis coordinate of the second recognition point
    --gcy2 : Y-axis coordinate of the second recognition point
    --gcol2 : Color of the second recognition point
--METHOD : action(seconds)
    --Tap the specified coordinates (wait for the specified number of seconds)
        --seconds : Wait time (in seconds)
--METHOD : compColor()
    --compares the two recognition points and returns 1 if they match, 0 if they do not match
--///////////////////////////////////////////////////////////////////////////
FindEnemy = Event.new(1547, 518, 1547, 518, 0x2D2D2C, 1584, 542, 0xA34236)
Attack = Event.new(1589, 520, 1554, 520, 0xF4E9E7, 1589, 520, 0xE4D8D7)
Camera = Event.new(83, 94)

--///////////////////////////////////////////////////////////////////////////
--TIMER OBJECT
--Class for measuring time
--INIT : Timer.new() return object
--METHOD : set()
    --Set the current time
--METHOD : distance()
    --Returns the time elapsed since the last set() call (in seconds)
--METHOD : reset()
    --Reset the elapsed time to 0
--///////////////////////////////////////////////////////////////////////////
FindEnemy_tm = Timer.new()

--///////////////////////////////////////////////////////////////////////////
--MAIN
--///////////////////////////////////////////////////////////////////////////

Logs("----------------START-----------------")

while true do

    -- Initial state
    if CONTROL == 0 then
        changeCtrl(1)
    end

    -- FindEnemy
    if CONTROL == 1 then
        FindEnemy_tm:set()
        FindEnemy:action(0.5)
        if FindEnemy:compColor() == 1 then
            changeCtrl(2)
            FindEnemy_tm:reset()
        end
        if FindEnemy_tm:distance() >= 15 then
            changeCtrl(10)
            FindEnemy_tm:reset()
        end
    end

    -- Attack
    if CONTROL == 2 then
        Attack:action(0.5)
        if Attack:compColor() == 1 then
            changeCtrl(0)
        end
    end

    -- Enemy Not Found (Camera move and FindEnemy)
    if CONTROL == 10 then
        Camera:action(0.5)
        FindEnemy:action(0.5)
        if FindEnemy:compColor() == 1 then
            changeCtrl(2)
        end
    end
end

--///////////////////////////////////////////////////////////////////////////
--EXAMPLE IMAGE SERCH
--///////////////////////////////////////////////////////////////////////////
img=Pattern("test.png"):similar(0.99) --similar : 0.0~1.0 (1.0:match only the same image)
rgn=Region(1112,160,1874-1112,1070-160) --Region(x,y,w,h)

imgTable=regionFindAllNoFindException(rgn,img) --return Location array
for i=1, #imgTable do
    click(imgTable[i])
    wait(0.5)
end