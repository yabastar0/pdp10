term.clear()
term.setCursorPos(1,1)

local originalPullEvent = os.pullEvent

os.pullEvent = function(filter)
    while true do
        local eventData = {originalPullEvent(filter)}
        
        if eventData[1] == "char" and string.match(eventData[2], "[a-z]") then
            eventData[2] = string.upper(eventData[2])
        end
        
        if eventData[1] ~= "terminate" then
            return table.unpack(eventData)
        end
    end
end

local fsbypass = {}
local rootFS = _G.fs
local function TOPERR(err)
    io.write("SYSTEM ERROR // "..err)
end

local function MOUNT(path,newpath)
    local oldnewpath = newpath
    local oldpath = path
    local newpath = rootFS.combine(newpath)
    if path:sub(1,3) == "DSK" then
        path = path:sub(1, -2)
        path = path:sub(4)
        if rootFS.exists("disk"..path) then
            fsbypass["disk"..path] = newpath
            io.write(oldpath.." MOUNTED TO "..oldnewpath)
        else
            TOPERR("COULD NOT MOUNT "..oldpath)
        end
    end
end

local function COPY(path,topath)
    local path = rootFS.combine(path)
    local topath = rootFS.combine(topath)
    if fs.exists(path) == false then
        TOPERR("INIT PATH FALSE "..path)
        return false
    end
    if fs.isDir(path) == true then
    
    end
    
    if fs.exists(topath) == false then
        TOPERR("RES PATH FALSE "..topath)
        return false
    end
    fs.copy(path,topath)
end

while true do
    io.write("\n.")
    local data = io.read()
    local args = {}
    for word in data:gmatch("%w+") do table.insert(args, word) end
    
    if args[1] == "MOUNT" then
        MOUNT(args[2], args[3])
    end
end
