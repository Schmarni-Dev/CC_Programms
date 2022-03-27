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
    local sPath = shell.resolve(localFile)
    local res = get(file,branch,user,repo)
    if res then
        local file = fs.open(sPath, "w")
        file.write(res)
        file.close()

        print("Downloaded as " .. localFile)
        return true
    end
    return false
end

return {getFile = use}


