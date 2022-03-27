local tArgs = { ... }
local gitlib = require("git-lib")


local function printInput()
    print("Inputs:")
    print("1: Local file name")
    print("2: file name on github")
    print("3: the github branch name")
    print("4: the repo owner")
    print("5: the repo name")
end


-- Download a file from Github.com
if #tArgs < 2 then
    printInput()
    return
end

-- Determine file to download
local sFile = tArgs[1]
local sCode = tArgs[2]
local sPath = shell.resolve(sFile)
if fs.exists(sPath) then
    print("File already exists")
    return
end


-- GET the contents from Github
if gitlib.getFile(sCode,tArgs[3],tArgs[4],tArgs[5],sFile) then
    shell.run(sPath)
end