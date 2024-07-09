local functions = require('lib.crackscript.functions')

local api = {}

api.log_chat_to_file = function(file_path, player_name, message)
    local file = io.open(file_path, "a")
    if file then
        file:write("[" .. os.date("%d.%m.%Y %X") .. "] " .. player_name .. ": " .. message .. "\n")
        file:flush()
        file:close()
    end
end

api.kick_if_prohibited_characters = function(player_name, message, debug_file_path, blacklist)
    if functions.contains_prohibited_characters(message, blacklist) then
        for _, pid in ipairs(players.list(true, true, true)) do
            if players.get_name(pid) == player_name then
                menu.trigger_commands("kick " .. player_name)
                functions.log_debug("Player kicked for prohibited characters: " .. player_name, debug_file_path)
                util.toast("Player kicked for prohibited characters: " .. player_name)
                break
            end
        end
    end
end

api.kick_all_players = function(debug_file_path, exclude_friends, exclude_org, exclude_crew, exclude_strangers)
    for _, pid in ipairs(players.list(true, true, true)) do
        if pid ~= players.user() and not functions.should_exclude_player(pid, exclude_friends, exclude_org, exclude_crew, exclude_strangers) then
            menu.trigger_commands("kick " .. players.get_name(pid))
        end
    end
    functions.log_debug("All players kicked", debug_file_path)
    util.toast("All players kicked")
end

api.crash_all_players = function(debug_file_path, exclude_friends, exclude_org, exclude_crew, exclude_strangers)
    for _, pid in ipairs(players.list(true, true, true)) do 
        if pid ~= players.user() and not functions.should_exclude_player(pid, exclude_friends, exclude_org, exclude_crew, exclude_strangers) then
            menu.trigger_commands("crash " .. players.get_name(pid))
        end
    end
    functions.log_debug("All players crashed", debug_file_path)
    util.toast("All players crashed")
end

api.detect_ip_and_respond = function(player_name, message, sender_id, debug_file_path)
    if functions.contains_ip(message) then
        local player_ip = functions.int_to_ip(players.get_ip(sender_id))
        local response = "Player " .. player_name .. " tried to share an IP address Here is their IP " .. player_ip
        chat.send_message(response, false, true, true) -- 1 = team chat, 2 = local history, 3 = global history -- HEIR WEITERMACHEN CRACKY!!!
        functions.log_debug("IP detected and responded: " .. player_name .. " - " .. player_ip, debug_file_path)
        util.toast("IP detected and responded: " .. player_name .. " - " .. player_ip)
    end
end

return api
