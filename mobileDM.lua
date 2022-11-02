-- set up inventory

-- goal: robot sets up dm (movement, item placement, inventory management)
-- runs it (dm documentation)
-- set up charger on quantum entangaloporter and sit
-- waits until it is done (dm documentation)
-- breaks the dm (opposite of sets up dm)
-- moves 32 block distance
-- repeat

-- ideally the robot has comms with the computer at all times, but if not it has to either
-- a. yell where it is at so we can pick it up (coord)
-- b. walk its ass back to base, if low power: place quantum entangloporter and charger and sit until charged then disassemble ? keep going

local d = require("devices")
local b = d:find("block_operations") -- break and place blocks
local i = d:find("inventory_operations") -- manipulate inventory
local r = d:find("robot") -- move robot
-- import tunnel library

local dmSlot = 1
local logPipeSlot = 2
local qeSlot = 3
local chargerSlot = 4

function operations ()
    -- wait for commands coroutine
    -- command = start
    if command.value == "assemble" then
        setupDM()
    end
    if command.value == "disassemble" then
        disassembleDM()
    end
    if command.value == "relocate" then
        relocate(command.direction)
    end
end

-- define set up inventory
function setupInventory ()
    if r:getStackInSlot(dmSlot).value ~= "dmValue" then
        -- look for a dm within inventory
        -- if find it, put it in correct slot
        i:move()
        -- else, throw a warning back to base
    end
    if r:getStackInSlot(logPipeSlot).value ~= "logPipeValue" and r:getStackInSlot(logPipeSlot).quantity < number then
    end
    if r:getStackInSlot(qeSlot).value ~= "QEvalue" then
    end
    if r:getStackInSlot(chargerSlot).value ~= "chargerValue" then
    end
end

function relocate (direction)
    for 1,32 do r:move(direction)
end

-- set up dm
function setupDM ()
    setUpInventory()
    r:setSelectedSlot(dmSlot) -- place dm
    b:place()
    wirePipes() -- place wires w/ end position where the qe should be
    r:setSelectedSlot(qeSlot) -- place quantum entangloporter
    r:move("up")
    b:place("down")
    r:setSelectedSlot(chargerSlot) -- place charger and stew in the energy juices
    r:move("up")
    b:place("down")
    turnOnDM() -- TODO implement turning on DM with redstone
end

-- reverse setupDM
function disassembleDM ()
    b:excavate("down") -- break charger
    r:move("down")
    b:excavate("down") -- break qe
    r:move("down")
    removePipes() -- break pipes
    b:excavate("front") -- break dm
end

-- wire pipes from initial placing of dm
function wirePipes ()
    r:setSelectedSlot(logPipeSlot)
    -- move to left side
    r:move("left")
    r:move("left")
    r:turn("right")
    r:turn("left")
    r:turn("left")

    -- place pipes TODO more
    r:move("left")
    b:place("left")
end

-- reverse wirePipes TODO 
function removePipes ()
end