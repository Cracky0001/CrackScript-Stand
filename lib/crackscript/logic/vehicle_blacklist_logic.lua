function vehicleCheck()
    if vehicleCheckEnabled then
        local vehhashlist = {
            "oppressor2",
            "oppressor",
            "deluxo",
            "scramjet",
            "vigilante",
            "toreador",
            "strikeforce",
            "minitank"
        }

        -- Tick handler for regular checks
        util.create_tick_handler(function()
            if vehicleCheckEnabled then
                for _, pid in ipairs(players.list(true, false, false)) do -- Check for players
                    local model = players.get_vehicle_model(pid)
                    for _, vehhash in ipairs(vehhashlist) do
                        if model == util.joaat(vehhash) then
                            -- Get the position and cause an explosion on them
                            local pos = players.get_position(pid)
                            ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, false, true, 0.0)
                            util.toast(players.get_name(pid) .. " was in a " .. vehhash .. " - Boom!")
                        end
                    end
                end
            end
            util.yield(10) -- Wait 5 seconds before the next check
        end)
    end
end
