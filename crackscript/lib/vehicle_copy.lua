local vehicle_copy = {}

-- Logging Funktion
local function log(message)
    util.log("[Vehicle Copy] " .. message)
end

local function safe_call(func, description)
    local status, err = pcall(func)
    if not status then
        log("Error during " .. description .. ": " .. err)
        util.toast("Error during " .. description .. ": " .. err)
    end
end

-- Funktion zum Kopieren der Fahrzeugmodifikationen
function vehicle_copy.copy_vehicle_modifications(sourceVehicle, targetVehicle)
    if not VEHICLE.IS_VEHICLE_DRIVEABLE(sourceVehicle, false) or not VEHICLE.IS_VEHICLE_DRIVEABLE(targetVehicle, false) then
        log("Source or target vehicle is not driveable.")
        return
    end

    -- Neonlichter kopieren
    safe_call(function()
        for i = 0, 3 do
            if VEHICLE.GET_VEHICLE_NEON_ENABLED(sourceVehicle, i) then
                VEHICLE.SET_VEHICLE_NEON_ENABLED(targetVehicle, i, true)
            end
        end

        local r, g, b = memory.alloc_int(), memory.alloc_int(), memory.alloc_int()
        VEHICLE.GET_VEHICLE_NEON_COLOUR(sourceVehicle, r, g, b)
        VEHICLE.SET_VEHICLE_NEON_COLOUR(targetVehicle, memory.read_int(r), memory.read_int(g), memory.read_int(b))
    end, "copying neon lights")

    -- Kennzeichen kopieren
    safe_call(function()
        local plateText = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(sourceVehicle)
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(targetVehicle, plateText)
        local plateIndex = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(sourceVehicle)
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(targetVehicle, plateIndex)
    end, "copying license plate")

    -- Modifikationen kopieren
    safe_call(function()
        for i = 0, 49 do
            local modIndex = VEHICLE.GET_VEHICLE_MOD(sourceVehicle, i)
            if modIndex ~= -1 then
                VEHICLE.SET_VEHICLE_MOD(targetVehicle, i, modIndex)
            end
        end
    end, "copying modifications")

    -- Toggle Mods kopieren
    safe_call(function()
        for i = 17, 22 do
            if VEHICLE.IS_TOGGLE_MOD_ON(sourceVehicle, i) then
                VEHICLE.TOGGLE_VEHICLE_MOD(targetVehicle, i, true)
            end
        end
    end, "copying toggle mods")

    -- Radtyp kopieren
    safe_call(function()
        local wheelType = VEHICLE.GET_VEHICLE_WHEEL_TYPE(sourceVehicle)
        VEHICLE.SET_VEHICLE_WHEEL_TYPE(targetVehicle, wheelType)

        -- Überprüfen und Kopieren der Reifen
        for i = 23, 24 do
            local wheelModIndex = VEHICLE.GET_VEHICLE_MOD(sourceVehicle, i)
            if wheelModIndex ~= -1 then
                VEHICLE.SET_VEHICLE_MOD(targetVehicle, i, wheelModIndex)
            end
        end
    end, "copying wheel type and mods")

    -- Reifenrauchfarbe kopieren
    safe_call(function()
        local r, g, b = memory.alloc_int(), memory.alloc_int(), memory.alloc_int()
        VEHICLE.GET_VEHICLE_TYRE_SMOKE_COLOR(sourceVehicle, r, g, b)
        VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(targetVehicle, memory.read_int(r), memory.read_int(g), memory.read_int(b))
    end, "copying tire smoke color")

    -- Fenster getönt kopieren
    safe_call(function()
        local tint = VEHICLE.GET_VEHICLE_WINDOW_TINT(sourceVehicle)
        VEHICLE.SET_VEHICLE_WINDOW_TINT(targetVehicle, tint)
    end, "copying window tint")

    -- Livery kopieren
    safe_call(function()
        local liveryIndex = VEHICLE.GET_VEHICLE_LIVERY(sourceVehicle)
        VEHICLE.SET_VEHICLE_LIVERY(targetVehicle, liveryIndex)
    end, "copying livery")

    -- Primär- und Sekundärfarben kopieren (Benutzerdefinierte Farben)
    safe_call(function()
        local pr, pg, pb = memory.alloc_int(), memory.alloc_int(), memory.alloc_int()
        VEHICLE.GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(sourceVehicle, pr, pg, pb)
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(targetVehicle, memory.read_int(pr), memory.read_int(pg), memory.read_int(pb))
        
        local sr, sg, sb = memory.alloc_int(), memory.alloc_int(), memory.alloc_int()
        VEHICLE.GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(sourceVehicle, sr, sg, sb)
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(targetVehicle, memory.read_int(sr), memory.read_int(sg), memory.read_int(sb))
    end, "copying custom primary and secondary colors")

    -- Benutzerdefinierte Farben kopieren
    safe_call(function()
        local pearlescentColor, wheelColor = memory.alloc_int(), memory.alloc_int()
        VEHICLE.GET_VEHICLE_EXTRA_COLOURS(sourceVehicle, pearlescentColor, wheelColor)
        VEHICLE.SET_VEHICLE_EXTRA_COLOURS(targetVehicle, memory.read_int(pearlescentColor), memory.read_int(wheelColor))
    end, "copying custom colors")

    -- Akzentfarben kopieren
    safe_call(function()
        local accentColor = memory.alloc_int()
        VEHICLE.GET_VEHICLE_EXTRA_COLOUR_5(sourceVehicle, accentColor)
        if memory.read_int(accentColor) ~= nil then
            VEHICLE.SET_VEHICLE_EXTRA_COLOUR_5(targetVehicle, memory.read_int(accentColor))
        else
            log("Accent color is nil")
        end
    end, "copying accent colors")

    -- Xenon-Scheinwerfer kopieren
    safe_call(function()
        if VEHICLE.IS_TOGGLE_MOD_ON(sourceVehicle, 22) then
            VEHICLE.TOGGLE_VEHICLE_MOD(targetVehicle, 22, true)
            local xenonColor = VEHICLE.GET_VEHICLE_XENON_LIGHT_COLOR_INDEX(sourceVehicle)
            VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(targetVehicle, xenonColor)
        end
    end, "copying xenon lights")

    -- Kugelsichere Reifen kopieren
    safe_call(function()
        if VEHICLE.GET_VEHICLE_TYRES_CAN_BURST then
            local canBurst = VEHICLE.GET_VEHICLE_TYRES_CAN_BURST(sourceVehicle)
            VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(targetVehicle, canBurst)
        end
    end, "copying bulletproof tires")

    -- Panzerung kopieren
    safe_call(function()
        if VEHICLE.GET_VEHICLE_MOD(sourceVehicle, 16) then
            local armor = VEHICLE.GET_VEHICLE_MOD(sourceVehicle, 16)
            VEHICLE.SET_VEHICLE_MOD(targetVehicle, 16, armor)
        else
            log("GET_VEHICLE_ARMOUR function not found")
        end
    end, "copying armor")

    -- Extras kopieren (wie Dachoptionen)
    safe_call(function()
        for i = 0, 20 do
            if VEHICLE.DOES_EXTRA_EXIST(sourceVehicle, i) then
                local isExtraOn = VEHICLE.IS_VEHICLE_EXTRA_TURNED_ON(sourceVehicle, i)
                VEHICLE.SET_VEHICLE_EXTRA(targetVehicle, i, isExtraOn and 0 or 1)
            end
        end
    end, "copying extras")
end

-- Funktion zum Kopieren des aktuellen Fahrzeugs
function vehicle_copy.copy_current_vehicle()
    local status, err = pcall(function()
        local playerPed = PLAYER.PLAYER_PED_ID()
        local sourceVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
        if sourceVehicle == 0 then
            util.toast("Player is not in a vehicle.")
            return
        end

        local coords = ENTITY.GET_ENTITY_COORDS(sourceVehicle, true)
        local heading = ENTITY.GET_ENTITY_HEADING(sourceVehicle)
        local model = ENTITY.GET_ENTITY_MODEL(sourceVehicle)
        local velocity = ENTITY.GET_ENTITY_VELOCITY(sourceVehicle)

        -- Neues Fahrzeug ein paar Meter vor dem aktuellen Fahrzeug spawnen
        local offsetCoords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(sourceVehicle, 0, 5.0, 0)

        -- Neues Fahrzeug mit Stand API erstellen
        local targetVehicle = entities.create_vehicle(model, offsetCoords, heading)
        ENTITY.SET_ENTITY_VELOCITY(targetVehicle, velocity.x, velocity.y, velocity.z)
        vehicle_copy.copy_vehicle_modifications(sourceVehicle, targetVehicle)
        util.toast("Vehicle copied successfully.")

        -- Spieler ins neue Fahrzeug setzen
        PED.SET_PED_INTO_VEHICLE(playerPed, targetVehicle, -1)
    end)

    if not status then
        log("Error copying current vehicle: " .. err)
        util.toast("Error copying current vehicle: " .. err)
    end
end

return vehicle_copy
