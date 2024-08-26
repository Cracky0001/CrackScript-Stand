-- Globale Version
versionNum = "0.1.0"

-- Fehlerbehandlung für xpcall
local function try_catch(func, catch_func)
    local status, result = xpcall(func, debug.traceback)
    if not status then
        catch_func(result)
    end
end

-- Debugging Funktion
local function debug_print(message)
    util.log("[CrackScript Debug]: " .. message)
end

-- Internetverbindung und Update-Check
local function check_internet_access(callback)
    debug_print("Überprüfe Internetverbindung...")

    if async_http.have_access() then
        try_catch(function()
            async_http.init("www.google.com", "/", function(body, headers, status_code)
                debug_print("Internetverbindung Status Code: " .. status_code)
                callback(status_code == 200)
            end, function(reason)
                debug_print("Internetverbindung fehlgeschlagen: " .. reason)
                callback(false)
            end)
            async_http.dispatch()
        end, function(error)
            debug_print("Fehler bei der Überprüfung der Internetverbindung: " .. error)
            callback(false)
        end)
    else
        debug_print("Kein HTTP-Zugriff verfügbar.")
        callback(false)
    end
end

local function download_file(path, callback)
    local base_url = "raw.githubusercontent.com"
    local full_path = "/Cracky0001/CrackScript-Stand/main/" .. path
    local script_dir = filesystem.scripts_dir() .. "/"
    local save_path = script_dir .. path

    debug_print("Beginne Download: " .. full_path)

    try_catch(function()
        async_http.init(base_url, full_path, function(body, headers, status_code)
            debug_print("Download Status Code für " .. path .. ": " .. status_code)
            if status_code == 200 then
                local file = io.open(save_path, "w")
                if file then
                    file:write(body)
                    file:close()
                    debug_print("Datei gespeichert: " .. save_path)
                    callback(true)
                else
                    debug_print("Speichern der Datei fehlgeschlagen: " .. save_path)
                    callback(false)
                end
            else
                debug_print("Download der Datei fehlgeschlagen: " .. path .. " (HTTP " .. status_code .. ")")
                callback(false)
            end
        end, function(reason)
            debug_print("Download fehlgeschlagen: " .. path .. " - " .. reason)
            callback(false)
        end)
        async_http.dispatch()
    end, function(error)
        debug_print("Fehler beim Download der Datei: " .. error)
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

    debug_print("Beginne Update der Dateien...")
    local updated_files = 0
    for _, file in ipairs(files) do
        download_file(file, function(success)
            if success then
                updated_files = updated_files + 1
                if updated_files == #files then
                    debug_print("Alle Dateien erfolgreich aktualisiert.")
                    callback(true)
                end
            else
                debug_print("Update der Dateien fehlgeschlagen.")
                callback(false)
            end
        end)
    end
end

local function check_for_update(callback)
    local base_url = "raw.githubusercontent.com"
    local path = "/Cracky0001/CrackScript-Stand/main/CrackScript.lua"

    debug_print("Überprüfe auf Updates...")

    try_catch(function()
        async_http.init(base_url, path, function(body)
            debug_print("Response erhalten: " .. body:sub(1, 500))  -- Zeigt die ersten 500 Zeichen der Antwort an
            local remote_version = body:match('versionNum%s*=%s*"(%d+%.%d+%.%d+)"')
            debug_print("Gefundene Remote-Version: " .. (remote_version or "Unbekannt"))

            if remote_version then
                if remote_version > versionNum then
                    debug_print("Neue Version verfügbar: " .. remote_version)
                    util.toast("Neues Update verfügbar. Aktualisierung läuft...")
                    update_files(function(success)
                        if success then
                            debug_print("Update erfolgreich.")
                            util.toast("Update erfolgreich. Skript wird neu gestartet.")
                            callback(remote_version)
                        else
                            callback(versionNum)
                        end
                    end)
                elseif remote_version == versionNum then
                    debug_print("Die neueste Version wird bereits verwendet: " .. versionNum)
                    util.toast("Sie verwenden die neueste Version (" .. versionNum .. ").")
                    callback(versionNum)
                else
                    debug_print("Entwicklerversion erkannt: " .. versionNum)
                    util.toast("Sie verwenden eine Entwicklerversion (" .. versionNum .. "), die noch nicht veröffentlicht wurde.")
                    callback(versionNum)
                end
            else
                debug_print("Fehler bei der Überprüfung der Version. Lokale Version wird verwendet.")
                callback(versionNum)
            end
        end, function(reason)
            debug_print("Fehler bei der Versionsprüfung: " .. reason)
            callback(versionNum)
        end)
        async_http.dispatch()
    end, function(error)
        debug_print("Fehler bei der Überprüfung auf Updates: " .. error)
        callback(versionNum)
    end)
end


-- Hauptfunktion
local function main()
    debug_print("Starte Hauptfunktion...")
    check_internet_access(function(internet_available)
        if internet_available then
            check_for_update(function(version)
                versionNum = version
                require("lib.crackscript.menu") -- Hauptmenü laden
            end)
        else
            debug_print("Keine Internetverbindung erkannt.")
            menu.trigger_ccommand("stopluaCrackScript")

        end
    end)
end

try_catch(main, function(error)
    debug_print("Fehler in der Hauptfunktion: " .. error)
end)
