local running = true
local mainMenu = {"Start", "Debug", "Exit"}
mainMenu.select = "Start"
local windowsstate = 0
local mouselastclick = {}
mouselastclick.x = 0
mouselastclick.y = 0
local mouseclickt = false
local debug = false
local startup = false
-- Return de lenght van een table
function tableLenght(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- clear de temrinal en zet curise op 1,1 positie
function clear()
    term.clear()
    term.setCursorPos(1, 1)

end
-- tekent een menu in het midden van scherm op bazig van de strings die worden gelevert
function drawMenu(stringTable)
    local lenght = tableLenght(stringTable)
    local terug
    for i = 1, #stringTable do
        if (mouselastclick.y == i - 1) then
            if (mainMenu.select == stringTable[i] and mouseclickt) then
                term.write("!")
                terug = i
            end
            mainMenu.select = stringTable[i]
            term.write("[")
            term.write(stringTable[i])
            term.write("]")
            print()
        else
            print(stringTable[i])
        end
    end
    return terug
end
-- main loop voor program
while running do
    if (startup) then
        event, param1, param2, param3, param4, param5 = os.pullEvent()
    end
    if event == "terminate" then
        running = false
    elseif event == "mouse_click" then
        mouselastclick.x = param2
        mouselastclick.y = param3
        mouseclickt = true
    else
        mouseclickt = false
    end
    clear()
    if (windowsstate == 0) then
        local geklickt = drawMenu(mainMenu)
        if (debug) then print(geklickt) end
        if (geklickt == nil or geklickt == '') then
            -- doe nikst
        elseif geklickt == 1 then
            -- doe iets met start
        elseif geklickt == 2 then
            -- doe iets met debug 
            debug = not debug
        elseif geklickt == 3 then
            -- exit program
            running = false
        else
            -- overig
        end
    end
    term.setCursorPos(44, 18)
    if debug then
        print(mouselastclick.x, mouselastclick.y)
        term.setCursorPos(44, 18)
    end
    if (not startup) then startup = true end
    if (not running) then clear() end
end