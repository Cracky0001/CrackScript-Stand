-- Global Version
versionNum = "0.1.4"

-- Error handling for xpcall
local function try_catch(func, catch_func)
    local status, result = xpcall(func, debug.traceback)
    if not status then
        catch_func(result)
    end
end

-- Debugging function
local function debug_print(message)
    util.log("[CrackScript Debug]: " .. message)
end

-- Function to create missing directories
local function ensure_directories_exist()
    local directories = {
        "lib",
        "lib/crackscript",
        "lib/crackscript/lib"
    }

    for _, dir in ipairs(directories) do
        local full_path = filesystem.scripts_dir() .. "/" .. dir
        if not filesystem.exists(full_path) then
            debug_print("Creating directory: " .. full_path)
            filesystem.mkdirs(full_path)
        end
    end
end

-- Function to check if files exist
local function check_files_exist(files)
    for _, file in ipairs(files) do
        local full_path = filesystem.scripts_dir() .. "/" .. file
        if not filesystem.exists(full_path) then
            debug_print("File not found: " .. full_path)
            return false
        end
    end
    return true
end

-- Internet connection and update check
local function check_internet_access(callback)
    debug_print("Checking internet connection...")

    if async_http.have_access() then
        try_catch(function()
            async_http.init("www.google.com", "/", function(body, headers, status_code)
                debug_print("Internet connection status code: " .. status_code)
                callback(status_code == 200)
            end, function(reason)
                debug_print("Internet connection failed: " .. reason)
                callback(false)
            end)
            async_http.dispatch()
        end, function(error)
            debug_print("Error checking internet connection: " .. error)
            callback(false)
        end)
    else
        debug_print("No HTTP access available.")
        callback(false)
    end
end

local function download_file(path, callback)
    local base_url = "raw.githubusercontent.com"
    local full_path = "/Cracky0001/CrackScript-Stand/main/" .. path
    local script_dir = filesystem.scripts_dir() .. "/"
    local save_path = script_dir .. path

    debug_print("Starting download: " .. full_path)

    try_catch(function()
        async_http.init(base_url, full_path, function(body, headers, status_code)
            debug_print("Download status code for " .. path .. ": " .. status_code)
            if status_code == 200 then
                local file = io.open(save_path, "w")
                if file then
                    file:write(body)
                    file:close()
                    debug_print("File saved: " .. save_path)
                    callback(true)
                else
                    debug_print("Failed to save file: " .. save_path)
                    callback(false)
                end
            else
                debug_print("Download failed: " .. path .. " (HTTP " .. status_code .. ")")
                callback(false)
            end
        end, function(reason)
            debug_print("Download failed: " .. path .. " - " .. reason)
            callback(false)
        end)
        async_http.dispatch()
    end, function(error)
        debug_print("Error downloading file: " .. error)
        callback(false)
    end)
end

local function update_files(callback)
    local files = {
        "CrackScript.lua",
        "lib/crackscript/menu.lua",
        "lib/crackscript/libs/function.lua"
    }

    debug_print("Starting file update...")
    local updated_files = 0
    for _, file in ipairs(files) do
        download_file(file, function(success)
            if success then
                updated_files = updated_files + 1
                if updated_files == #files then
                    debug_print("All files updated successfully.")
                    callback(true)
                end
            else
                debug_print("File update failed.")
                callback(false)
            end
        end)
    end
end

local function check_for_update(callback)
    local base_url = "raw.githubusercontent.com"
    local path = "/Cracky0001/CrackScript-Stand/main/CrackScript.lua"

    debug_print("Checking for updates...")

    try_catch(function()
        async_http.init(base_url, path, function(body)
            debug_print("Response received: " .. body:sub(1, 500))  -- Shows the first 500 characters of the response
            local remote_version = body:match('versionNum%s*=%s*"(%d+%.%d+%.%d+)"')
            debug_print("Remote version found: " .. (remote_version or "Unknown"))

            if remote_version then
                if versionNum ~= remote_version then
                    if remote_version > versionNum then
                        debug_print("New version available: " .. remote_version)
                        util.toast("New update available. Updating now...")
                        update_files(function(success)
                            if success then
                                debug_print("Update successful.")
                                util.toast("Update successful. Restarting script.")
                                callback(remote_version)
                            else
                                callback(versionNum)
                            end
                        end)
                    else
                        debug_print("Developer version detected: " .. versionNum)
                        util.toast("You are using a developer version (" .. versionNum .. ") that has not yet been released.")
                        callback(versionNum)
                    end
                else
                    debug_print("Latest version already in use: " .. versionNum)
                    util.toast("You are using the latest version (" .. versionNum .. ").")
                    callback(versionNum)
                end
            else
                debug_print("Error checking version. Using local version.")
                callback(versionNum)
            end
        end, function(reason)
            debug_print("Version check failed: " .. reason)
            callback(versionNum)
        end)
        async_http.dispatch()
    end, function(error)
        debug_print("Error checking for updates: " .. error)
        callback(versionNum)
    end)
end

-- Main function
local function main()
    debug_print("Starting main function...")
    
    ensure_directories_exist()

    local files = {
        "CrackScript.lua",
        "lib/crackscript/menu.lua",
        "lib/crackscript/libs/functions.lua",
        "lib/crackscript/libs/crackessentials.lua"
    }

    if not check_files_exist(files) then
        debug_print("At least one file is missing. Starting update...")
        util.toast("Files missing. Starting update...")
        update_files(function(success)
            if success then
                check_for_update(function(version)
                    versionNum = version
                    require("lib.crackscript.menu") -- Load main menu
                end)
            else
                debug_print("Update failed.")
            end
        end)
    else
        check_internet_access(function(internet_available)
            if internet_available then
                check_for_update(function(version)
                    versionNum = version
                    require("lib.crackscript.menu") -- Load main menu
                end)
            else
                debug_print("No internet connection detected. Skipping update check.")
                util.toast("No internet connection detected. Skipping update check.")
                require("lib.crackscript.menu") -- Load main menu without internet connection
            end
        end)
    end
end

try_catch(main, function(error)
    debug_print("Error in main function: " .. error)
end)
