util.require_natives(1663599433)

local functions = require('lib.crackscript.functions')
local api = require('lib.crackscript.api')

local scriptHome = filesystem.scripts_dir() .. "/CrackScript/"
local debug_file_path = scriptHome .. "debug.txt"
local chat_log_file_path = scriptHome .. "chat_log.txt"
local blacklist_file_path = scriptHome .. "antiRus.txt"

functions.create_directory(scriptHome)
functions.generate_blacklist(blacklist_file_path)

local log_chat_toggle = false
local kick_prohibited_chat_toggle = false
local detect_ip_toggle = false
local anti_barcode_toggle = false

local exclude_friends_toggle = false
local exclude_org_toggle = false
local exclude_crew_toggle = false
local exclude_strangers_toggle = false

local blacklist = functions.load_blacklist(blacklist_file_path)

local main_menu = menu.my_root()

local crack_script_menu = menu.list(main_menu, "CrackScript", {}, "Options for CrackScript")

local chat_options_menu = menu.list(crack_script_menu, "Chat Options", {}, "Options for chat")
chat_options_menu:toggle("Log Chat to Textfile", {}, "Log all chat messages to a text file", function(state)
    log_chat_toggle = state
    functions.log_debug("Log Chat to Textfile toggled: " .. tostring(state), debug_file_path)
    util.toast("Log Chat to Textfile toggled: " .. tostring(state))
end, false)
chat_options_menu:toggle("Kick Russian/Chinese Chatters", {}, "Kick players using Russian or Chinese characters", function(state)
    kick_prohibited_chat_toggle = state
    functions.log_debug("Kick Russian/Chinese Chatters toggled: " .. tostring(state), debug_file_path)
    util.toast("Kick Russian/Chinese Chatters toggled: " .. tostring(state))
end, false)
chat_options_menu:toggle("Anti IP Share", {}, "Detect IP addresses in chat and respond with sender's IP", function(state)
    detect_ip_toggle = state
    functions.log_debug("Detect IP Addresses toggled: " .. tostring(state), debug_file_path)
    util.toast("Detect IP Addresses toggled: " .. tostring(state))
end, false)

chat.on_message(function(packet_sender, message_sender, message_text, is_team_chat)
    local player_name = players.get_name(message_sender)
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
end)

local toxic_menu = menu.list(crack_script_menu, "Toxic", {}, "Toxic actions")
local exclude_options_menu = menu.list(toxic_menu, "Exclude", {}, "Exclude Options")
exclude_options_menu:toggle("Exclude Friends (BROKE)", {}, "Exclude friends from actions", function(state)
    exclude_friends_toggle = state
    functions.log_debug("Exclude Friends toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Friends toggled: " .. tostring(state))
end, false)
exclude_options_menu:toggle("Exclude Organization", {}, "Exclude organization members from actions", function(state)
    exclude_org_toggle = state
    functions.log_debug("Exclude Organization toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Organization toggled: " .. tostring(state))
end, false)
exclude_options_menu:toggle("Exclude Crew", {}, "Exclude crew members from actions", function(state)
    exclude_crew_toggle = state
    functions.log_debug("Exclude Crew toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Crew toggled: " .. tostring(state))
end, false)
exclude_options_menu:toggle("Exclude Strangers", {}, "Exclude strangers from actions", function(state)
    exclude_strangers_toggle = state
    functions.log_debug("Exclude Strangers toggled: " .. tostring(state), debug_file_path)
    util.toast("Exclude Strangers toggled: " .. tostring(state))
end, false)

toxic_menu:action("Kick All Players", {"kickall"}, "Kick all players in the lobby", function()
    api.kick_all_players(debug_file_path, exclude_friends_toggle, exclude_org_toggle, exclude_crew_toggle, exclude_strangers_toggle)
    util.toast("Kicked all players in the lobby")
end)
toxic_menu:action("Crash All Players", {"crashall"}, "Crash all players in the lobby", function()
    api.crash_all_players(debug_file_path, exclude_friends_toggle, exclude_org_toggle, exclude_crew_toggle, exclude_strangers_toggle)
    util.toast("Crashed all players in the lobby")
end)
toxic_menu:action("Kick Session Host", {"kicksessionhost"}, "Kick the session host", function()
    local host_id = players.get_host()
    if host_id == players.user() then
        util.toast("You are the session host. Kicking yourself will disconnect you from the session. Are you sure you want to proceed? Type /yes to confirm.")
        
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
end)

toxic_menu:toggle("Anti-Barcode", {}, "Kick players with barcode-style names", function(state)
    anti_barcode_toggle = state
    functions.log_debug("Anti-Barcode toggled: " .. tostring(state), debug_file_path)
    util.toast("Anti-Barcode toggled: " .. tostring(state))
end, false)

local function kick_barcode_players()
    for _, pid in ipairs(players.list(true, true, true)) do
        local player_name = players.get_name(pid)
        if functions.is_barcode_name(player_name) then
            menu.trigger_commands("kick " .. player_name)
            functions.log_debug("Kicked barcode player: " .. player_name, debug_file_path)
            util.toast("Kicked barcode player: " .. player_name)
        end
    end
end

players.on_join(function(pid)
    if anti_barcode_toggle then
        local player_name = players.get_name(pid)
        if functions.is_barcode_name(player_name) then
            menu.trigger_commands("kick " .. player_name)
            functions.log_debug("Kicked barcode player on join: " .. player_name, debug_file_path)
            util.toast("Kicked barcode player on join: " .. player_name)
        end
    end
end)

if anti_barcode_toggle then
    kick_barcode_players()
end

toxic_menu:action("Kick All Modders", {"kickmodders"}, "Kick all modders in the lobby", function()
    for _, pid in ipairs(players.list(true, true, true)) do
        if players.is_marked_as_modder(pid) then
            local should_kick = true

            if exclude_friends_toggle and players.is_friend(pid) then
                should_kick = false
            end

            if exclude_org_toggle and players.get_boss(pid) == players.get_boss(players.user()) then
                should_kick = false
            end

            if exclude_crew_toggle and players.get_crew(pid) == players.get_crew(players.user()) then
                should_kick = false
            end

            if exclude_strangers_toggle and not players.is_friend(pid) and players.get_boss(pid) ~= players.get_boss(players.user()) and players.get_crew(pid) ~= players.get_crew(players.user()) then
                should_kick = false
            end

            if should_kick then
                menu.trigger_commands("kick " .. players.get_name(pid))
                functions.log_debug("Kicked modder: " .. players.get_name(pid), debug_file_path)
                util.toast("Kicked modder: " .. players.get_name(pid))
            end
        end
    end
end)
