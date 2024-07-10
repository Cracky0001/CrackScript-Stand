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
            if players.get_name(pid) == player_name and pid ~= players.user() then
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
    if sender_id ~= players.user() and functions.contains_ip(message) then
        local player_ip = functions.int_to_ip(players.get_ip(sender_id))
        local response = "Player " .. player_name .. " tried to share an IP address. Here is their IP: " .. player_ip
        local response2 = "This is what happens when you try to leak other player's IPs"
        local response3 = "You are a bad person " .. player_name
        local response4 = "Provided through CrackScript by cracky0001 on GitHub"
        chat.send_message(response3, false, true, true)
        chat.send_message(response, false, true, true)
        chat.send_message(response2, false, true, true)
        chat.send_message(response4, false, true, true)
        functions.log_debug("IP detected and responded: " .. player_name .. " - " .. player_ip, debug_file_path)
        util.toast("IP detected and responded: " .. player_name .. " - " .. player_ip)
    end
end

api.handle_chat_message = function(log_chat_toggle, kick_prohibited_chat_toggle, detect_ip_toggle, player_name, message_text, message_sender, chat_log_file_path, debug_file_path, blacklist)
    functions.log_debug("Chat message received - Player: " .. player_name .. ", Message: " .. message_text, debug_file_path)
    if log_chat_toggle then
        api.log_chat_to_file(chat_log_file_path, player_name, message_text)
    end
    if kick_prohibited_chat_toggle then
        api.kick_if_prohibited_characters(player_name, message_text, debug_file_path, blacklist)
    end
    if detect_ip_toggle then
        api.detect_ip_and_respond(player_name, message_text, message_sender, debug_file_path)
    end
end

api.kick_session_host = function(debug_file_path)
    local host_id = players.get_host()
    if host_id == players.user() then
        util.toast("You are the session host you idiot!")
        
        chat.on_message(function(packet_sender, message_sender, message_text, is_team_chat)
            if players.get_name(message_sender) == players.get_name(players.user()) and message_text == "/yes" then
                menu.trigger_commands("kick " .. players.get_name(host_id))
                functions.log_debug("Kicked self as session host", debug_file_path)
                util.toast("Kicked self as session host")
            end
        end)
    else
        menu.trigger_commands("kick " .. players.get_name(host_id))
        functions.log_debug("Kicked session host: " .. players.get_name(host_id), debug_file_path)
        util.toast("Kicked session host: " .. players.get_name(host_id))
    end
end

api.kick_all_modders = function(debug_file_path, exclude_friends, exclude_org, exclude_crew, exclude_strangers)
    for _, pid in ipairs(players.list(true, true, true)) do
        if players.is_marked_as_modder(pid) then
            local should_kick = true

            if pid == players.user() then
                should_kick = false
            end

            if exclude_friends and players.is_friend(pid) then
                should_kick = false
            end

            if exclude_org and players.get_boss(pid) == players.get_boss(players.user()) then
                should_kick = false
            end

            if exclude_crew and players.get_crew(pid) == players.get_crew(players.user()) then
                should_kick = false
            end

            if exclude_strangers and not players.is_friend(pid) and players.get_boss(pid) ~= players.get_boss(players.user()) and players.get_crew(pid) ~= players.get_crew(players.user()) then
                should_kick = false
            end

            if should_kick then
                menu.trigger_commands("kick " .. players.get_name(pid))
                functions.log_debug("Kicked modder: " .. players.get_name(pid), debug_file_path)
                util.toast("Kicked modder: " .. players.get_name(pid))
            end
        end
    end
end

api.kick_random_player = function(debug_file_path)
    local all_players = players.list(true, true, true)
    local eligible_players = {}

    for _, pid in ipairs(all_players) do
        if pid ~= players.user() then
            table.insert(eligible_players, pid)
        end
    end

    if #eligible_players > 0 then
        local random_index = math.random(#eligible_players)
        local random_player = eligible_players[random_index]
        local random_player_name = players.get_name(random_player)
        menu.trigger_commands("kick " .. random_player_name)
        functions.log_debug("Random player kicked: " .. random_player_name, debug_file_path)
        util.toast("Random player kicked: " .. random_player_name)
    else
        util.toast("No other players to kick")
    end
end

return api
