-- Globale Version
versionNum = "0.1.1"

-- Fehlerbehandlung für xpcall
local function try_catch(func, catch_func)
    local status, result = xpcall(func, debug.traceback)
    if not status then
        catch_func(result)
    end
end

-- Internetverbindung und Update-Check
local function check_internet_access(callback)
    if async_http.have_access() then
        try_catch(function()
            async_http.init("www.google.com", "/", function(body, headers, status_code)
                callback(status_code == 200)
            end, function(reason)
                callback(false)
            end)
            async_http.dispatch()
        end, function(error)
            callback(false)
        end)
    else
        callback(false)
    end
end

local function download_file(path, callback)
    local base_url = "raw.githubusercontent.com"
    local full_path = "/Cracky0001/CrackScript-Stand/main/" .. path
    local script_dir = filesystem.scripts_dir() .. "/"
    local save_path = script_dir .. path

    try_catch(function()
        async_http.init(base_url, full_path, function(body, headers, status_code)
            if status_code == 200 then
                local file = io.open(save_path, "w")
                if file then
                    file:write(body)
                    file:close()
                    callback(true)
                else
                    callback(false)
                end
            else
                callback(false)
            end
        end, function(reason)
            callback(false)
        end)
        async_http.dispatch()
    end, function(error)
        callback(false)
    end)
end

local function update_files(callback)
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
        "lib/crackscript/logic/anti_ip_share_logic.lua"
    }

    local updated_files = 0
    for _, file in ipairs(files) do
        download_file(file, function(success)
            if success then
                updated_files = updated_files + 1
                if updated_files == #files then
                    callback(true)
                end
            else
                callback(false)
            end
        end)
    end
end

local function check_for_update(callback)
    local base_url = "raw.githubusercontent.com"
    local path = "/Cracky0001/CrackScript-Stand/main/CrackScript.lua"

    try_catch(function()
        async_http.init(base_url, path, function(body)
            local remote_version = body:match('versionNum%s*=%s*"(%d+%.%d+%.%d+)"')

            if remote_version then
                if remote_version > versionNum then
                    util.toast("Neues Update verfügbar. Aktualisierung läuft...")
                    update_files(function(success)
                        if success then
                            util.toast("Update erfolgreich. Skript wird neu gestartet.")
                            callback(remote_version)
                        else
                            callback(versionNum)
                        end
                    end)
                elseif remote_version == versionNum then
                    callback(versionNum)
                else
                    util.toast("Sie verwenden eine Entwicklerversion (" .. versionNum .. "), die noch nicht veröffentlicht wurde.")
                    callback(versionNum)
                end
            else
                callback(versionNum)
            end
        end, function(reason)
            callback(versionNum)
        end)
        async_http.dispatch()
    end, function(error)
        callback(versionNum)
    end)
end

local function ensure_directories_exist()
    local directories = {
        "lib",
        "lib/crackscript",
        "lib/crackscript/logic"
    }

    for _, dir in ipairs(directories) do
        local full_path = filesystem.scripts_dir() .. "/" .. dir
        if not filesystem.exists(full_path) then
            filesystem.mkdirs(full_path)
        end
    end
end

local function check_files_exist(files)
    for _, file in ipairs(files) do
        local full_path = filesystem.scripts_dir() .. "/" .. file
        if not filesystem.exists(full_path) then
            return false
        end
    end
    return true
end

-- Hauptfunktion
local function main()
    ensure_directories_exist()

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
        "lib/crackscript/logic/anti_ip_share_logic.lua"
    }

    if not check_files_exist(files) then
        util.toast("Dateien fehlen. Starte Update...")
        update_files(function(success)
            if success then
                check_for_update(function(version)
                    versionNum = version
                    require("lib.crackscript.menu") -- Hauptmenü laden
                end)
            end
        end)
    else
        check_internet_access(function(internet_available)
            if internet_available then
                check_for_update(function(version)
                    versionNum = version
                    require("lib.crackscript.menu") -- Hauptmenü laden
                end)
            else
                util.toast("Keine Internetverbindung erkannt. Update-Check übersprungen.")
                require("lib.crackscript.menu") -- Hauptmenü laden, auch ohne Internetverbindung
            end
        end)
    end
end

try_catch(main, function(error)
    util.toast("Fehler in der Hauptfunktion: " .. error)
end)
