local functions = require('CrackScript.lib.functions')
local chat_kick = require('CrackScript.lib.chat_kick')

local exclude_handler = {}

local exclude_self_toggle, exclude_friends_toggle = true, false
local kick_prohibited_chat_toggle, detect_ip_toggle, anti_barcode_toggle = false, false, false

function exclude_handler.set_exclude_self(state)
    exclude_self_toggle = state
end

function exclude_handler.set_exclude_friends(state)
    exclude_friends_toggle = state
end

function exclude_handler.set_kick_prohibited_chat(state)
    kick_prohibited_chat_toggle = state
end

function exclude_handler.set_detect_ip(state)
    detect_ip_toggle = state
end

function exclude_handler.set_anti_barcode(state)
    anti_barcode_toggle = state
end

local function isFriend(playerId)
    local success, result = pcall(function()
        local handle = memory.alloc(104)
        NETWORK.NETWORK_HANDLE_FROM_PLAYER(playerId, handle, 13)
        return NETWORK.NETWORK_IS_HANDLE_VALID(handle, 13) and NETWORK.NETWORK_IS_FRIEND(handle)
    end)
    return success and result
end

local function shouldExcludePlayer(playerId)
    return (exclude_self_toggle and playerId == players.user()) or (exclude_friends_toggle and isFriend(playerId))
end

exclude_handler.kick_all_players = function(debug_file_path)
    for _, pid in ipairs(players.list(true, true, true)) do
        if not shouldExcludePlayer(pid) then
            menu.trigger_commands("kick " .. players.get_name(pid))
        end
    end
    functions.log_debug("All players kicked", debug_file_path)
    util.toast("All players kicked")
end

exclude_handler.crash_all_players = function(debug_file_path)
    for _, pid in ipairs(players.list(true, true, true)) do
        if not shouldExcludePlayer(pid) then
            menu.trigger_commands("crash " .. players.get_name(pid))
        end
    end
    functions.log_debug("All players crashed", debug_file_path)
    util.toast("All players crashed")
end

exclude_handler.kick_all_modders = function(debug_file_path)
    for _, pid in ipairs(players.list(true, true, true)) do
        if players.is_marked_as_modder(pid) and not shouldExcludePlayer(pid) then
            menu.trigger_commands("kick " .. players.get_name(pid))
            functions.log_debug("Kicked modder: " .. players.get_name(pid), debug_file_path)
            util.toast("Kicked modder: " .. players.get_name(pid))
        end
    end
end

exclude_handler.kick_random_player = function(debug_file_path)
    local eligible_players = {}
    for _, pid in ipairs(players.list(true, true, true)) do
        if not shouldExcludePlayer(pid) then
            table.insert(eligible_players, pid)
        end
    end
    if #eligible_players > 0 then
        local random_player = eligible_players[math.random(#eligible_players)]
        menu.trigger_commands("kick " .. players.get_name(random_player))
        functions.log_debug("Random player kicked: " .. players.get_name(random_player), debug_file_path)
        util.toast("Random player kicked: " .. players.get_name(random_player))
    else
        util.toast("No other players to kick")
    end
end

exclude_handler.check_and_block_barcode = function(pid)
    if anti_barcode_toggle and players.get_name(pid):match("^[Il1|]+$") and not shouldExcludePlayer(pid) then
        menu.trigger_commands("block " .. players.get_name(pid))
        functions.log_debug("Blocked barcode player: " .. players.get_name(pid))
        util.toast("Blocked barcode player: " .. players.get_name(pid))
    end
end

exclude_handler.handle_chat_message = function(log_chat_toggle, kick_prohibited_chat_toggle, detect_ip_toggle, player_name, message_text, message_sender, chat_log_file_path, debug_file_path)
    functions.log_debug("Chat message received - Player: " .. player_name .. ", Message: " .. message_text, debug_file_path)
    if log_chat_toggle then
        functions.log_chat_to_file(chat_log_file_path, player_name, message_text)
    end
    if kick_prohibited_chat_toggle and not shouldExcludePlayer(message_sender) then
        if chat_kick.contains_prohibited_characters(message_text) then
            menu.trigger_commands("kick " .. player_name)
            functions.log_debug("Player kicked for prohibited characters: " .. player_name, debug_file_path)
            util.toast("Player kicked for prohibited characters: " .. player_name)
        end
    end
    if detect_ip_toggle and not shouldExcludePlayer(message_sender) then
        if functions.contains_ip(message_text) then
            local player_ip = functions.int_to_ip(players.get_ip(message_sender))
            local response = "Player " .. player_name .. " tried to share an IP address. Here is their IP: " .. player_ip
            chat.send_message(response, false, true, true)
            functions.log_debug("IP detected and responded: " .. player_name .. " - " .. player_ip, debug_file_path)
            util.toast("IP detected and responded: " .. player_name .. " - " .. player_ip)
        end
    end
end

return exclude_handler
