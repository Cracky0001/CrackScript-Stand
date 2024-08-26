-- VersionNum wird später definiert
local versionNum = "0.0.1"

-- Updater ausführen und dann Hauptmenü laden
local updater = require("lib.crackscript.updater")

updater.check_for_update(function(version)
    versionNum = version or "0.0.1"  -- Version wird nach dem Update-Check gesetzt
    require("lib.crackscript.menu")   -- Hauptmenü laden
end)

local base_url = "raw.githubusercontent.com/Cracky0001/CrackScript/main/"
local script_dir = filesystem.scripts_dir()
local files = {
    "CrackScript.lua",
    "lib/crackscript/menu.lua",
    "lib/crackscript/logic/anti_barcode_logic.lua",
    "lib/crackscript/logic/vehicle_blacklist_logic.lua",
    "lib/crackscript/logic/crash_random_logic.lua",
    "lib/crackscript/logic/kick_everyone_logic.lua",
    "lib/crackscript/logic/kick_random_logic.lua",
    "lib/crackscript/logic/kick_modders_logic.lua",
    "lib/crackscript/logic/kick_host_logic.lua",
    "lib/crackscript/logic/kick_russian_chinese_logic.lua",
    "lib/crackscript/logic/anti_ip_share_logic.lua",
    "lib/crackscript/updater.lua"
}

-- Function to ensure directories exist
local function ensure_directories_exist()
    local directories = {
        "lib",
        "lib/crackscript",
        "lib/crackscript/logic"
    }

    for _, dir in ipairs(directories) do
        local full_path = script_dir .. "/" .. dir
        if not filesystem.exists(full_path) then
            filesystem.mkdirs(full_path)
        end
    end
end

-- Function to check internet access
local function check_internet_access(callback)
    async_http.init("www.google.com", "/", function(body, headers, status_code)
        callback(status_code == 200)
    end, function()
        callback(false)
    end)
    async_http.dispatch()
end

local function download_file(path, callback)
    async_http.init(base_url, path, function(body, headers, status_code)
        if status_code == 200 then
            local file = io.open(script_dir .. path, "w")
            file:write(body)
            file:close()
            callback(true)
        else
            callback(false)
        end
    end, function() callback(false) end)
    async_http.dispatch()
end

local function update_files(callback)
    ensure_directories_exist()  -- Ensure all directories exist before downloading
    local errors = {}
    for _, file in ipairs(files) do
        download_file(file, function(success)
            if not success then table.insert(errors, file) end
            if #errors > 0 then
                util.toast("Failed to update: " .. table.concat(errors, ", "))
            else
                util.toast("Update successful. Restart the script.")
            end
            callback()  -- Callback aufrufen, wenn die Updates abgeschlossen sind
        end)
    end
end

local function check_version(callback)
    async_http.init(base_url, "CrackScript.lua", function(body)
        local remote_version = body:match('versionNum%s*=%s*"(%d+%.%d+%.%d+)"')
        if remote_version then
            if remote_version > versionNum then
                update_files(function()
                    callback(remote_version)
                end)
            else
                util.toast("You have the latest version.")
                callback(remote_version)
            end
        else
            util.toast("Failed to fetch version information.")
            callback(versionNum)
        end
    end)
    async_http.dispatch()
end

-- Main function to start the update process with internet check
local function main(callback)
    check_internet_access(function(internet_available)
        if internet_available then
            util.toast("Internet connection detected.")
            check_version(callback)
        else
            util.toast("No internet connection detected. Update check skipped.")
            callback(versionNum)
        end
    end)
end

return { check_for_update = main }
