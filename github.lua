local tArgs = { ... }

local function printInput()
    print("Inputs:")
    print("1: Local file name")
    print("2: file name on github")
    print("3: the github branch name")
    print("4: the repo owner")
    print("5: the repo name")
end

local function get(file,branch,user,repo)

    if user == nil or user == "s" then
        user = "Schmarni-Dev"
    end
    if repo == nil then
        repo = "CCT_lua_stuff"
    end
    if branch == nil then
        branch = "main"
    end
    local gitdata = user.."/"..repo.."/"..branch.."/".."/"..file


    -- Add a cache buster so that spam protection is re-checked
    local cacheBuster = ("%x"):format(math.random(0, 2 ^ 30))
    local response, err = http.get(
        "https://raw.githubusercontent.com/" .. textutils.urlEncode(gitdata) .. "?cb=" .. cacheBuster
    )

    if response then

        -- error Idk what went wrong. "if even possible, just something from the pastebin code"
        local headers = response.getResponseHeaders()
        if not headers["Content-Type"] or not headers["Content-Type"]:find("^text/plain") then
            io.stderr:write("Failed.\n")
            print("IDK why")
            return
        end

        print("Success.")

        local sResponse = response.readAll()
        response.close()
        return sResponse
    else
        io.stderr:write("Failed.\n")
        print(err)
    end
end

local function use(file,branch,user,repo,localFile)
    local sFile = file
    if localFile ~= nil then
        local sFile = localFile
    end
    local sPath = shell.resolve(sFile)
    local res = get(file,branch,user,repo)
    if res then
        local file = fs.open(sPath, "w")
        file.write(res)
        file.close()

        print("Downloaded as " .. sFile)
        return true
    end
    return false
end

if true then

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
    if use(sCode,tArgs[3],tArgs[4],tArgs[5],sFile) then
        if tArgs[6] == "true" then
            shell.run(sPath)
        end
    end

end

return {getFile = use}


