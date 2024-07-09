-- lib/crackscript/api.lua
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
        local player_id = players.get_by_name(player_name)
        if player_id then
            menu.trigger_commands("kick " .. player_name)
            functions.log_debug("Player kicked for prohibited characters: " .. player_name, debug_file_path)
        end
    end
end

api.respond_to_chat_message = function(player_name, message, chatbot_data)
    local lower_message = message:lower()
    for _, trigger in pairs(chatbot_data.triggers) do
        for _, keyword in ipairs(trigger.keywords) do
            if lower_message:find(keyword:lower()) then
                local response = trigger.responses[math.random(#trigger.responses)]:format(player_name)
                chat.send_message(response, false, true, true)
                return true, response
            end
        end
    end
    return false, nil
end

api.kick_all_players = function(debug_file_path)
    for _, pid in ipairs(players.list(true, true, true)) do
        if pid ~= players.user() then
            menu.trigger_commands("kick " .. players.get_name(pid))
        end
    end
    functions.log_debug("All players kicked", debug_file_path)
end

api.crash_all_players = function(debug_file_path)
    for _, pid in ipairs(players.list(true, true, true)) do
        if pid ~= players.user() then
            menu.trigger_commands("crash " .. players.get_name(pid))
        end
    end
    functions.log_debug("All players crashed", debug_file_path)
end

api.detect_ip_and_respond = function(player_name, message, debug_file_path)
    if functions.contains_ip(message) then
        local player_id = players.get_by_name(player_name)
        if player_id then
            local player_ip = functions.int_to_ip(players.get_ip(player_id))
            chat.send_message("IP of " .. player_name .. ": " .. player_ip, false, true, true)
            functions.log_debug("IP detected and responded: " .. player_name .. " - " .. player_ip, debug_file_path)
        end
    end
end

return api
