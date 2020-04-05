 --Note: Computer craft has an issue where turtles will break if left in unloaded chunks, keep near the turtle or use a worldspike.
 
--This is version 1.2.4, updates will replace the current pastebin with the newer version once they're done!
--Added a boring mode that mines a single layer, good for underground strip mining.
 
--How to use:
--Place a chest to the left of the turtle for fuel and a chest behind it for a place to drop off items.
--"Quarry or bore?" Type "quarry" for a quarry or "bore" to mine a single layer. Make sure you type in all lowercase.
--"Rows" If looking from above, this is how many blocks it will mine in the 'y' axis.
--"Columns" If looking from above, this is how many blocks it will mine in the 'x' axis.
--"Current 'y' level?" The 'y' level of the turtle.
--"Toss garbage blocks?" Type "yes" to toss out stone, gravel, dirt, etc. Make sure you type in all lowercase.
 
term.clear()
term.setCursorPos(1,1)
io.write("Quarry or bore? ")
quarrybore = io.read()
term.clear()
term.setCursorPos(1,1)
io.write("Rows: ")
rows = io.read()
io.write("Columns: ")
columns = io.read()
iniY = 2
if quarrybore == "quarry" then
    term.clear()
    term.setCursorPos(1,1)
    io.write("Current 'y' level: ")
    iniY = io.read()
end
term.clear()
term.setCursorPos(1,1)
io.write("Toss garbage blocks? ")
tossGarbage = io.read()
term.clear()
term.setCursorPos(1,1)
 
posX = 0
posY = 0
posZ = 0
 
rotation = 0
 
fullSlots = 0
 
function info()
    term.clear()
    term.setCursorPos(1,1)
    print("Please send suggestions to:")
    print("Discord: Gambit#9026")
    print("Reddit: Grieferrimix_")
    print("---------------------------------------")
    print("Mining size: " .. rows .. " by " .. columns)
--  print("Total distance: " .. posX + posY + posZ)
--  print("X: " .. posX)
--  print("Y: " .. posY)
--  print("Z: " .. posZ)
--  print("Orientation: " .. rotation)
    if tossGarbage == "yes" then
        print("Toss garbage: Yes")
    else
        print("Toss garbage: No")
    end
    print("")
    print("Fuel level: " .. turtle.getFuelLevel())
end
 
function rotate()
    if rotation == 0 then
        turtle.turnLeft()
    elseif rotation == 1 then
        turtle.turnLeft()
        turtle.turnLeft()
    elseif rotation == 2 then
        turtle.turnRight()
    end
end
 
function recover()
    rotate()
    local step = 0
    for step = posY - 1, 0, -1 do
        turtle.up()
    end
    for step = posX - 1, 0, -1 do
        turtle.forward()
    end
    turtle.turnLeft()
    for step = posZ - 1, 0, -1 do
        turtle.forward()
    end
end
 
function resume()
    turtle.turnLeft()
    turtle.turnLeft()
    local step = 0
    for step = 0, posZ - 1, 1 do
        turtle.forward()
    end
    turtle.turnRight()
    for step = 0, posX - 1, 1 do
        turtle.forward()
    end
    for step = 0, posY - 1, 1 do
        turtle.down()
    end
    if rotation == 0 then
        turtle.turnLeft()
    elseif rotation == 2 then
        turtle.turnRight()
    elseif rotation == 3 then
        turtle.turnRight()
        turtle.turnRight()
    end
end
 
function checkFuel()
    turtle.select(1)
    turtle.refuel()
    if turtle.getFuelLevel() <= posX + posY + posZ + 1 then
        refill = 1
        empty()
        refill = 0
    end
end
 
function empty()
    recover()
    if quarrybore == "bore" then
        turtle.down()
    end
    local search = 0
    for search = 16, 1, -1 do
        turtle.select(search)
        turtle.drop()
    end
    if refill == 1 then
        turtle.turnRight()
        while turtle.getFuelLevel() <= posX + posY + posZ + 1 do
            if turtle.suck() == true then
                turtle.suck()
                turtle.select(1)
                turtle.refuel()
            elseif turtle.suck() == false then
                turtle.select(1)
                turtle.refuel()
                term.clear()
                term.setCursorPos(1,1)
                io.write("Please add more fuel to slot '1' or fuel chest.")
            end
        end
        turtle.turnLeft()
        resume()
    end
    if done ~= 1 then
        if quarrybore == "bore" then
            turtle.up()
        end
        resume()
    end
end
 
function checkFull()
    fullSlots = 0
    local search = 0
    for search = 16, 1, -1 do
        turtle.select(search)
        if turtle.getItemCount() > 0 then
            if tossGarbage == "yes" then
                if turtle.getItemDetail().name == "minecraft:cobblestone" then
                    turtle.drop()
                elseif turtle.getItemDetail().name == "minecraft:stone" then
                    turtle.drop()
                elseif turtle.getItemDetail().name == "minecraft:dirt" then
                    turtle.drop()
                elseif turtle.getItemDetail().name == "minecraft:gravel" then
                    turtle.drop()
                elseif turtle.getItemDetail().name == "chisel:marble2" then
                    turtle.drop()
                elseif turtle.getItemDetail().name == "chisel:limestone2" then
                    turtle.drop()
                elseif turtle.getItemDetail().name == "minecraft:netherrack" then
                    turtle.drop()
                elseif turtle.getItemDetail().name == "natura:nether_tainted_soil" then
                    turtle.drop()
                end
            end
        end
        if turtle.getItemCount() > 0 then
            fullSlots = fullSlots + 1
        end
    end
    if fullSlots == 16 then
        empty()
    end
end
 
function nextRow()
    if turn == 0 then
        turtle.turnRight()
        rotation = 1
        digStraight()
        turtle.turnRight()
        rotation = 2
        turn = 1
    elseif turn == 1 then
        turtle.turnLeft()
        rotation = 1
        digStraight()
        turtle.turnLeft()
        rotation = 0
        turn = 0
    elseif turn == 2 then
        turtle.turnRight()
        rotation = 3
        digStraight()
        turtle.turnRight()
        rotation = 0
        turn = 3
    elseif turn == 3 then
        turtle.turnLeft()
        rotation = 3
        digStraight()
        turtle.turnLeft()
        rotation = 2
        turn = 2
    end
end
 
function digDown()
    checkFuel()
    local step = 0
    for step = 2, 0, -1 do
        turtle.digDown()
        if turtle.down() == true then
            posY = posY + 1
        end
        info()
    end
end
 
function digStraight()
    checkFuel()
    turtle.digDown()
    turtle.dig()
    turtle.dig()
    turtle.forward()
    if rotation == 0 then
        posZ = posZ + 1
    elseif rotation == 1 then
        posX = posX + 1
    elseif rotation == 2 then
        posZ = posZ - 1
    elseif rotation == 3 then
        posX = posX - 1
    end
    turtle.digUp()
    info()
end
 
function quarry()
    turn = 0
    done = 0
    iniY = tonumber (iniY)
    checkFuel()
    turtle.digUp()
    turtle.up()
    posY = posY - 1
    while posY < iniY - 2 do
        if quarrybore == "quarry" then
            digDown()
        end
        for c = columns, 1, -1 do
            for r = rows, 2, -1 do
                digStraight()
            end
            checkFull()
            if c == 1 then
                turtle.turnRight()
                turtle.turnRight()
                if rotation == 0 then
                    rotation = 2
                elseif rotation == 2 then
                    rotation = 0
                end
                if turn == 0 then
                    turn = 2
                elseif turn == 1 then
                    turn = 3
                elseif turn == 2 then
                    turn = 0
                elseif turn == 3 then
                    turn = 1
                end
            elseif c > 1 then
                nextRow()
            end
        end
        if quarrybore == "bore" then
            posY = posY + 1
        end
    end
    turtle.digDown()
    done = 1
    empty()
    term.clear()
    term.setCursorPos(1,1)
    print("Thank you for using Gambit's quarry program!")
    print("---------------------------------------")
    print("Please send suggestions to:")
    print("Discord: Gambit#9026")
    print("Reddit: Grieferrimix_")
    print("")
end
 
quarry()