print("Running Updater")
local gitlib = require("git-lib")
local tArgs = {...}
local configPath = "config/updater.json"
local inputs = {
    example = {
        repo = "Above_and_Beyond_CC",
        user = "Schmarni-Dev",
        file = "printHelloWorld.lua",
        branch = "main"
    },
}

local function printInput()
    print("Inputs:")
    print("1: Valid preset name")
    print("presets can be edited at "..configPath)
    print("Valid presets")
    for k, v in pairs(inputs) do
        print(k) 
    end
end

local function readJson(path)
    local f = fs.open(path, "r")
    local diskjson = textutils.unserialiseJSON(f.readAll())
    f.close()
    return diskjson
end

local function isValid(input)
    if fs.exists(configPath) then
        inputs = readJson(configPath)
    else
        local f =fs.open(configPath,"w")
        f.write(textutils.serialiseJSON(inputs):gsub('",','",\n   '):gsub(':{',':{\n   '):gsub('}','\n}\n'))
    end

    for k, v in pairs(inputs) do
        if k == input then
            return true
        end
    end
    return false
end

local function Update(value)
    local t = inputs[value]
    local fPath = shell.resolve(t["file"])
    fs.delete(fPath)
    gitlib.getFile(t["file"], t["branch"], t["user"], t["repo"],t["file"])
    print("Done")
    if tArgs[2] == "true" then 
        shell.run(t["file"])
    end
end

if isValid(tArgs[1]) then
    Update(tArgs[1])
else
    print("Error: please supply valid args")
    -- print(textutils.serialiseJSON(inputs):gsub('",','",\n   '):gsub(':{',':{\n   '):gsub('}','\n}\n'))
    printInput()
end