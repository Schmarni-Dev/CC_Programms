local tArgs = { ... }


local function get(code,branch,user,repo)

    if user == nil then
        user = "Schmarni-Dev"
    end
    if repo == nil then
        repo = "CCT_lua_stuff"
    end
    if branch == nil then
        branch = "main"
    end
    local gitdata = user.."/"..repo.."/"..branch.."/".."/"..code


    -- Add a cache buster so that spam protection is re-checked
    local cacheBuster = ("%x"):format(math.random(0, 2 ^ 30))
    local response, err = http.get(
        "https://raw.githubusercontent.com/" .. textutils.urlEncode(gitdata) .. "?cb=" .. cacheBuster
    )

    if response then
        -- error Idk what went wrong
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

if true then
    -- Download a file from Github.com
    if #tArgs < 2 then
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
    local res = get(sCode,tArgs[3],tArgs[4],tArgs[5])
    if res then
        local file = fs.open(sPath, "w")
        file.write(res)
        file.close()

        print("Downloaded as " .. sFile)
    end
end


