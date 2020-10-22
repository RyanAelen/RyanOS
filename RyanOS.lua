-- !LUA
MAINWINDOW = 1;
START = "Start";
DEBUG = "Debug";
UPDATE = "Update";
EXIT = "Exit";
NOSELECT = "noSelect";
-- Program state
local state = {}
state.running = true
state.window = MAINWINDOW
state.startup = false
-- Main Menu
local mainMenu = {};
mainMenu.select = START;
mainMenu.list = {START, DEBUG, UPDATE, EXIT}
-- Mouse stuff
local mouselastclick = {}
mouselastclick.x = 0;
mouselastclick.y = 0;
mouselastclick.mouseclickt = false;
-- Debug option
local debug = false;
-- screen
local screen = {}
screen.x, screen.y = term.getSize()

-- Return de lenght van een table
function tableLenght(T)
    local count = 0;
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- clear de temrinal en zet curise op 1,1 positie
function clear()
    term.clear();
    term.setCursorPos(1, 1);
end
function switchDebug() debug = not debug end
function drawMenu(Menu)
    local menu = Menu
    if menu.list == nil then return nil end
    if menu.select == nil then return nil end
    term.setCursorPos(1, 1)
    local maxlengthtextinmenu = 0;
    for key, value in pairs(menu.list) do
        if maxlengthtextinmenu < string.len(menu.list[key]) then
            maxlengthtextinmenu = string.len(menu.list[key]);
        end
    end
    local drawX, drawY = nil;
    for key, value in pairs(menu.list) do
        if (screen.x > 7 and screen.y > 5) then
            term.setCursorPos(screen.x / 2 - (maxlengthtextinmenu / 2),
                              (screen.y / 2) - (#menu.list / 2) + key);
        end
        if (drawX == nil) then 
            drawX, drawY = term.getCursorPos() 
        end
        if (menu.select == menu.list[key]) then

            local x, y = term.getCursorPos()
            term.setCursorPos(x - 1, y)
            term.write("[");
            term.write(menu.list[key]);
            term.write("]");
        else
            term.write(menu.list[key]);
        end
        print();
    end
    return drawX,drawY;
end
function menu(Menu, Mouselastclick)
    assert(type(Mouselastclick.mouseclickt) == "boolean",
           "mouselickt in mouse moet boolean zijn")
    assert(type(Mouselastclick.x) == "number", "x moet nummer zijn")
    assert(type(Mouselastclick.y) == "number", "x moet nummer zijn")
    local drawX,drawY = drawMenu(Menu)
    if (Mouselastclick.mouseclickt) then
        for key, value in pairs(Menu.list) do
            if (mouselastclick.y == drawY + key-1) then
                print(drawY + key)
                Menu.select = Menu.list[key];
            end
        end
    end
    drawMenu(Menu)

end

while true do
    if (state.startup) then
        event, param1, param2, param3, param4, param5 = os.pullEvent()
    end
    if event == "terminate" then
        running = false;
    elseif event == "mouse_click" then
        mouselastclick.x = param2;
        mouselastclick.y = param3;
        mouselastclick.mouseclickt = true;
    else
        mouselastclick.mouseclickt = false;
    end
    if (not state.startup) then state.startup = true end
    screen.x, screen.y = term.getSize()
    clear()
    menu(mainMenu, mouselastclick)

    print(term.getSize())
    print(mouselastclick.x, mouselastclick.y)
    -- clear screen bij exit van programa
    if (not state.running and not debug) then clear() end
end
